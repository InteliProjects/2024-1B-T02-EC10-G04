package main

import (
	"log"
	"os"

	ourSwagDocs "github.com/Inteli-College/2024-1B-T02-EC10-G04/api"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/configs"
	initialization "github.com/Inteli-College/2024-1B-T02-EC10-G04/init"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/kafka"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/repository"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/web/handler"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/web/middleware"
	"github.com/joho/godotenv"
	"github.com/penglongli/gin-metrics/ginmetrics"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/usecase"
	ckafka "github.com/confluentinc/confluent-kafka-go/v2/kafka"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func init() {
	if _, stat_err := os.Stat("./.env"); stat_err == nil {
		err := godotenv.Load()
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	}

	if missing_var := initialization.VerifyEnvs(
		"POSTGRES_URL",
		"CONFLUENT_KAFKA_TOPIC_NAME",
		"CONFLUENT_API_KEY",
		"CONFLUENT_API_SECRET",
		"CONFLUENT_BOOTSTRAP_SERVER_SASL",
		"JWT_SECRET_KEY",
		"REDIS_PASSWORD",
		"REDIS_ADDRESS",
	); missing_var != nil {
		panic(missing_var)
	}
}

//	@title			Manager API
//	@version		1.0
//	@description	This is a.
//	@termsOfService	http://swagger.io/terms/

//	@contact.name	Manager API Support
//	@contact.url	https://github.com/Inteli-College/2024-1B-T02-EC10-G04
//	@contact.email	gomedicine@inteli.edu.br

//	@license.name	Apache 2.0
//	@license.url	http://www.apache.org/licenses/LICENSE-2.0.html

//	@host	localhost:8080
//	@BasePath	/api/v1

// @SecurityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @description "Type: Bearer token"
// @scheme bearer
// @bearerFormat JWT

func main() {
	/////////////////////// Configs /////////////////////////

	db := configs.SetupPostgres()
	defer db.Close()

	redis := configs.SetupRedis()
	defer func() {
		if err := redis.Close(); err != nil {
			log.Fatalf("Erro while closing connection with Redis: %v", err)
		}
	}()

	///////////////////////// Gin ///////////////////////////

	router := gin.Default()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())
	router.Use(cors.New(cors.Config{
		AllowAllOrigins:  true, // TODO: change to false and make it for production
		AllowMethods:     []string{"*"},
		ExposeHeaders:    []string{"*"},
		AllowCredentials: true,
	}))

	///////////////////// Logging //////////////////////

	m := ginmetrics.GetMonitor()
	m.SetMetricPath("/api/v1/metrics")
	m.Use(router)

	///////////////////// Base Group //////////////////////

	api := router.Group("/api/v1")

	///////////////////// Swagger //////////////////////
	if swaggerHost, ok := os.LookupEnv("SWAGGER_HOST"); ok {

		ourSwagDocs.SwaggerInfo.Host = swaggerHost
	}
	api.GET("/docs/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	///////////////////// Healthcheck //////////////////////

	// TODO: "http://localhost:8080/api/healthz" is the best pattern for healthcheck?

	router.GET("/api/v1/healthz", handler.HealthCheckHandler)

	//////////////////////// User ///////////////////////////

	userRepository := repository.NewUserRepositoryPostgres(db)
	userUseCase := usecase.NewUserUseCase(userRepository)
	userHandlers := handler.NewUserHandlers(userUseCase)

	{
		userGroup := api.Group("/users")
		{
			userGroup.POST("", userHandlers.CreateUser)
			userGroup.POST("/login", userHandlers.LoginUser)
			userGroup.GET("", middleware.AuthMiddleware(userRepository, []string{"admin", "manager"}), userHandlers.FindAllUsersHandler)
			// TODO: update find user by id to only show the user that is logged in
			userGroup.GET("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "manager"}), userHandlers.FindUserByIdHandler)
			// TODO: update update user by id to only update the user that is logged in
			userGroup.PUT("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "manager"}), userHandlers.UpdateUserHandler)
			userGroup.DELETE("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "manager"}), userHandlers.DeleteUserHandler)
		}
	}

	/////////////////////// Order /////////////////////////

	orderProducerConfigMap := &ckafka.ConfigMap{
		"bootstrap.servers": os.Getenv("CONFLUENT_BOOTSTRAP_SERVER_SASL"),
		"sasl.mechanisms":   "PLAIN",
		"security.protocol": "SASL_SSL",
		"sasl.username":     os.Getenv("CONFLUENT_API_KEY"),
		"sasl.password":     os.Getenv("CONFLUENT_API_SECRET"),
	}
	kafkaProducerRepository := kafka.NewKafkaProducer(orderProducerConfigMap)

	orderRepository := repository.NewOrderRepositoryPostgres(db)
	orderUseCase := usecase.NewOrderUseCase(orderRepository, userRepository)
	orderHandlers := handler.NewOrderHandlers(orderUseCase, kafkaProducerRepository)

	{
		orderGroup := api.Group("/orders")
		{
			orderGroup.POST("", middleware.AuthMiddleware(userRepository, []string{"admin", "user"}), orderHandlers.CreateOrdersHandler)
			orderGroup.GET("", middleware.AuthMiddleware(userRepository, []string{"admin", "manager"}), orderHandlers.FindAllOrdersHandler)
			orderGroup.GET("/collector", middleware.AuthMiddleware(userRepository, []string{"collector"}), orderHandlers.FindOrdersByCollectorHandler)
			orderGroup.GET("/user", middleware.AuthMiddleware(userRepository, []string{"user"}), orderHandlers.FindOrdersByUserHandler)
			orderGroup.GET("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), orderHandlers.FindOrderByIdHandler)
			orderGroup.PUT("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "manager", "collector"}), orderHandlers.UpdateOrderHandler)
			orderGroup.DELETE("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), orderHandlers.DeleteOrderHandler)
		}
	}

	///////////////////////// Medicine ///////////////////////////

	medicineRepository := repository.NewMediceRepositoryPostgres(db)
	medicineUseCase := usecase.NewMedicineUseCase(medicineRepository)
	medicineHandlers := handler.NewMedicineHandlers(medicineUseCase)

	{
		medicineGroup := api.Group("/medicines")
		{
			medicineGroup.POST("", middleware.AuthMiddleware(userRepository, []string{"admin"}), medicineHandlers.CreateMedicineHandler)
			medicineGroup.GET("", middleware.AuthMiddleware(userRepository, []string{"admin", "user"}), medicineHandlers.FindAllMedicinesHandler)
			medicineGroup.GET("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "user"}), medicineHandlers.FindMedicineByIdHandler)
			medicineGroup.PUT("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), medicineHandlers.UpdateMedicineHandler)
			medicineGroup.DELETE("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), medicineHandlers.DeleteMedicineHandler)
		}
	}

	/////////////////////// Pyxis /////////////////////////

	pyxisRepository := repository.NewPyxisRepositoryPostgres(db)
	medicinePyxisRepository := repository.NewMedicinePyxisRepositoryPostgres(db)
	medicineRedisRepository := repository.NewMedicineRepositoryRedis(redis)
	pyxisUseCase := usecase.NewPyxisUseCase(pyxisRepository, medicinePyxisRepository, medicineRedisRepository)
	pyxisHandlers := handler.NewPyxisHandlers(pyxisUseCase, medicineUseCase)

	{
		pyxisGroup := api.Group("/pyxis")

		{
			pyxisGroup.POST("", middleware.AuthMiddleware(userRepository, []string{"admin"}), pyxisHandlers.CreatePyxisHandler)
			pyxisGroup.GET("", middleware.AuthMiddleware(userRepository, []string{"admin", "user", "collector", "manager"}), pyxisHandlers.FindAllPyxisHandler)
			pyxisGroup.GET("/:id", middleware.AuthMiddleware(userRepository, []string{"admin", "user", "collector", "manager"}), pyxisHandlers.FindPyxisByIdHandler)
			pyxisGroup.PUT("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), pyxisHandlers.UpdatePyxisHandler)
			pyxisGroup.DELETE("/:id", middleware.AuthMiddleware(userRepository, []string{"admin"}), pyxisHandlers.DeletePyxisHandler)
			pyxisGroup.POST("/:id/register-medicine", middleware.AuthMiddleware(userRepository, []string{"admin"}), pyxisHandlers.RegisterMedicinePyxisHandler)
			pyxisGroup.GET("/:id/medicines", middleware.AuthMiddleware(userRepository, []string{"admin", "user", "collector", "manager"}), pyxisHandlers.GetMedicinesPyxisHandler)
			pyxisGroup.DELETE("/:id/medicines", middleware.AuthMiddleware(userRepository, []string{"admin"}), pyxisHandlers.DisassociateMedicinePyxisHandler)
			pyxisGroup.POST("/qrcode", middleware.AuthMiddleware(userRepository, []string{"admin", "user"}), pyxisHandlers.GeneratePyxisQRCodeHandler)
		}
	}

	err := router.Run(":8080")
	if err != nil {
		log.Fatal("Error running server:", err)
	}
}
