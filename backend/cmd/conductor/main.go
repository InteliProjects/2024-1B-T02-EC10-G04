package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/configs"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/kafka"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/repository"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/usecase"
	ckafka "github.com/confluentinc/confluent-kafka-go/v2/kafka"
	initialization "github.com/Inteli-College/2024-1B-T02-EC10-G04/init"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	// "log"
)

// Please use .env file for local development. After that, please comment out the lines below,
// their dependencies as well, and update the go.mod file with command $ go mod tidy.

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

//	@title			Conductor API
//	@version		1.0
//	@description	This is a.
//	@termsOfService	http://swagger.io/terms/

//	@contact.name	Conductor API Support
//	@contact.url	https://github.com/Inteli-College/2024-1B-T02-EC10-G04
//	@contact.email	gomedicine@inteli.edu.br

//	@license.name	Apache 2.0
//	@license.url	http://www.apache.org/licenses/LICENSE-2.0.html

//	@host		localhost:8084
//	@BasePath	/conductor

func main() {

	/////////////////////// Configs /////////////////////////

	db := configs.SetupPostgres()
	defer db.Close()

	///////////////////// Healthcheck //////////////////////

	router := gin.Default()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	//TODO: "http://localhost:8081/conductor/healthz" is the best pattern for healthcheck?

	// @Summary Healthcheck
	// @Description Check the health status of the service
	// @ID healthcheck
	// @Produce json
	// @Success 200 {object} gin.H
	// @Router /conductor/healthz [get]
	router.GET("/conductor/healthz", func(c *gin.Context) {
		log.Printf("Consumer received a healthcheck request")
		c.JSON(http.StatusOK, gin.H{"status": "success"})
	})

	go func() {
		if err := router.Run(":8081"); err != nil {
			log.Fatalf("Falha ao iniciar o servidor: %v", err)
		}
	}()

	//////////////////////// Orders Consumer //////////////////////////

	msgChan := make(chan *ckafka.Message)

	consumerConfigMap := &ckafka.ConfigMap{
		"bootstrap.servers":  os.Getenv("CONFLUENT_BOOTSTRAP_SERVER_SASL"),
		"sasl.mechanisms":    "PLAIN",
		"security.protocol":  "SASL_SSL",
		"sasl.username":      os.Getenv("CONFLUENT_API_KEY"),
		"sasl.password":      os.Getenv("CONFLUENT_API_SECRET"),
		"session.timeout.ms": 6000,
		"group.id":           "go-medicine",
		"auto.offset.reset":  "latest",
	}

	kafkaConsumerRepository := kafka.NewKafkaConsumer([]string{os.Getenv("CONFLUENT_KAFKA_TOPIC_NAME")}, consumerConfigMap)
	orderRepository := repository.NewOrderRepositoryPostgres(db)
	userRepository := repository.NewUserRepositoryPostgres(db)
	ordersUseCase := usecase.NewOrderUseCase(orderRepository, userRepository)

	go func() {
		if err := kafkaConsumerRepository.Consume(msgChan); err != nil {
			log.Printf("Error consuming kafka queue: %v", err)
		}
	}()

	for msg := range msgChan {
		var orderInputDTO dto.CreateOrdersInputDTO
		err := json.Unmarshal(msg.Value, &orderInputDTO)
		if err != nil {
			log.Printf("Error decoding message: %v", err)
		}
		res, err := ordersUseCase.CreateOrders(&orderInputDTO)
		if err != nil {
			log.Printf("Error creating order entity: %v", err)
		}
		log.Printf("Orders created with id: %v", res)
	}
}
