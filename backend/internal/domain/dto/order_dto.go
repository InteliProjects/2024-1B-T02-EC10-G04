package dto

import (
	"time"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
)

type CreateOrdersInputDTO struct {
	Priority       string   `json:"priority" binding:"required"`
	User_ID        string   `json:"user_id"`
	Observation    *string  `json:"observation"`
	Medicine_IDs   []string `json:"medicine_ids" binding:"required"`
	Responsible_ID string   `json:"responsible_id"`
	Pyxis_ID       string   `json:"pyxis_id" binding:"required"`
}

type FindOrderByIDInputDTO struct {
	ID string `json:"id"`
}

type UpdateOrderInputDTO struct {
	Order_ID       string  `json:"order_id"`
	Priority       *string `json:"priority"`
	Observation    *string `json:"observation"`
	Status         *string `json:"status"`
	Responsible_ID *string `json:"responsible_id"`
}

type DeleteOrderInputDTO struct {
	ID string `json:"id"`
}

type CreateOrderOutputDTO struct {
	ID             string    `json:"id"`
	Priority       string    `json:"priority"`
	User_ID        string    `json:"user_id"`
	Observation    *string   `json:"observation"`
	Status         string    `json:"status"`
	Responsible_ID *string   `json:"responsible_id"`
	Medicine_ID    string    `json:"medicine_id"`
	CreatedAt      time.Time `json:"created_at"`
	OrderGroup_ID  *string   `json:"order_group_id"`
}

type FindOrderOutputDTO struct {
	ID             string             `json:"id"`
	Order_ID       string             `json:"order_id"`
	Priority       string             `json:"priority"`
	Observation    *string            `json:"observation"`
	Status         string             `json:"status"`
	CreatedAt      time.Time          `json:"created_at"`
	UpdatedAt      time.Time          `json:"updated_at"`
	User           entity.User        `json:"user"`
	Medicine       []*entity.Medicine `json:"medicine"`
	Responsible    *entity.User       `json:"responsible,omitempty"`
	Medicine_ID    string             `json:"medicine_id,omitempty"`
	User_ID        string             `json:"user_id,omitempty"`
	Responsible_ID *string            `json:"responsible_id,omitempty"`
	Pyxis_ID       string             `json:"pyxis_id,omitempty"`
}

type UpdateOrderOutputDTO struct {
	Order_ID    string             `json:"order_id"`
	User        entity.User        `json:"user_id"`
	Observation *string            `json:"observation,omitempty"`
	Priority    string             `json:"priority"`
	Status      string             `json:"status"`
	UpdatedAt   time.Time          `json:"updated_at"`
	CreatedAt   time.Time          `json:"created_at"`
	Responsible *entity.User       `json:"responsible,omitempty"`
	Medicines   []*entity.Medicine `json:"medicines"`
}

type DeleteOrderOutputDTO struct {
	ID string `json:"id"`
}
