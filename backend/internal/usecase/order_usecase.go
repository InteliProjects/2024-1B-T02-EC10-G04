package usecase

import (
	"log"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/google/uuid"
)

type OrderUseCase struct {
	orderRepository entity.OrderRepository
	userRepository  entity.UserRepository
}

func NewOrderUseCase(orderRepository entity.OrderRepository, userRepository entity.UserRepository) *OrderUseCase {
	return &OrderUseCase{
		orderRepository: orderRepository,
		userRepository:  userRepository,
	}
}

func (o *OrderUseCase) CreateOrders(input *dto.CreateOrdersInputDTO) ([]*dto.CreateOrderOutputDTO, error) {
	newOrderGroupID := uuid.New().String()
	createdOrders := []*dto.CreateOrderOutputDTO{}
	for _, medicine_id := range input.Medicine_IDs {
		order := entity.NewOrder(input.Priority, input.User_ID, input.Observation, medicine_id, input.Responsible_ID, newOrderGroupID, input.Pyxis_ID)
		res, err := o.orderRepository.CreateOrder(order)
		if err != nil {
			return nil, err
		}
		createdOrders = append(createdOrders, &dto.CreateOrderOutputDTO{
			ID:             res.ID,
			Priority:       res.Priority,
			User_ID:        res.User_ID,
			Observation:    res.Observation,
			Responsible_ID: res.Responsible_ID,
			Status:         res.Status,
			Medicine_ID:    res.Medicine_ID,
			CreatedAt:      res.CreatedAt,
			OrderGroup_ID:  res.OrderGroup_ID,
		})
	}
	return createdOrders, nil
}

func (o *OrderUseCase) FindOrdersByUser(id string) ([]*dto.FindOrderOutputDTO, error) {
	orders, err := o.orderRepository.FindOrdersByUser(id)
	if err != nil {
		return nil, err
	}
	var ordersOutput []*dto.FindOrderOutputDTO
	for i := 0; i < len(orders); i++ {
		temp := dto.FindOrderOutputDTO{
			ID:          orders[i].ID,
			Order_ID:    *orders[i].OrderGroup_ID,
			Priority:    orders[i].Priority,
			User:        orders[i].User,
			Observation: orders[i].Observation,
			Status:      orders[i].Status,
			Medicine:    []*entity.Medicine{&orders[i].Medicine},
			UpdatedAt:   orders[i].UpdatedAt,
			CreatedAt:   orders[i].CreatedAt,
			Responsible: orders[i].Responsible,
			Pyxis_ID:    orders[i].Pyxis_ID,
		}
		next := 1
		for {
			if next+i < len(orders)-1 && *orders[i+next].OrderGroup_ID == *orders[i].OrderGroup_ID {
				temp.Medicine = append(temp.Medicine, &orders[i+next].Medicine)
				next++
				continue
			} else {
				i = i + next
				break
			}
		}
		ordersOutput = append(ordersOutput, &temp)
	}
	return ordersOutput, nil
}

func (o *OrderUseCase) FindOrdersByCollector(id string) ([]*dto.FindOrderOutputDTO, error) {
	orders, err := o.orderRepository.FindOrdersByCollector(id)
	if err != nil {
		return nil, err
	}
	var ordersOutput []*dto.FindOrderOutputDTO
	for i := 0; i < len(orders); i++ {
		temp := dto.FindOrderOutputDTO{
			ID:          orders[i].ID,
			Order_ID:    *orders[i].OrderGroup_ID,
			Priority:    orders[i].Priority,
			User:        orders[i].User,
			Observation: orders[i].Observation,
			Status:      orders[i].Status,
			Medicine:    []*entity.Medicine{&orders[i].Medicine},
			UpdatedAt:   orders[i].UpdatedAt,
			CreatedAt:   orders[i].CreatedAt,
			Responsible: orders[i].Responsible,
			Pyxis_ID:    orders[i].Pyxis_ID,
		}
		next := 1
		for {
			if next+i < len(orders)-1 && *orders[i+next].OrderGroup_ID == *orders[i].OrderGroup_ID {
				temp.Medicine = append(temp.Medicine, &orders[i+next].Medicine)
				next++
				continue
			} else {
				i = i + next
				break
			}
		}
		ordersOutput = append(ordersOutput, &temp)
	}
	return ordersOutput, nil
}

func (o *OrderUseCase) FindAllOrders() ([]*dto.FindOrderOutputDTO, error) {
	orders, err := o.orderRepository.FindAllOrders()
	if err != nil {
		return nil, err
	}
	var ordersOutput []*dto.FindOrderOutputDTO
	for i := 0; i < len(orders); i++ {
		temp := dto.FindOrderOutputDTO{
			ID:          orders[i].ID,
			Order_ID:    *orders[i].OrderGroup_ID,
			Priority:    orders[i].Priority,
			User:        orders[i].User,
			Observation: orders[i].Observation,
			Status:      orders[i].Status,
			Medicine:    []*entity.Medicine{&orders[i].Medicine},
			UpdatedAt:   orders[i].UpdatedAt,
			CreatedAt:   orders[i].CreatedAt,
			Responsible: orders[i].Responsible,
			Pyxis_ID:    orders[i].Pyxis_ID,
		}

		next := 1
		for {
			if next+i < len(orders)-1 && *orders[i+next].OrderGroup_ID == *orders[i].OrderGroup_ID {
				temp.Medicine = append(temp.Medicine, &orders[i+next].Medicine)
				next++
				continue
			} else {
				i = i + next
				break
			}
		}

		ordersOutput = append(ordersOutput, &temp)
	}
	return ordersOutput, nil
}

func (o *OrderUseCase) FindOrderById(id string) (*dto.FindOrderOutputDTO, error) {
	order, err := o.orderRepository.FindOrderById(id)
	if err != nil {
		return nil, err
	}

	log.Printf("Ordergroup_id: %s\n", *order.OrderGroup_ID)
	remainingOrders, new_err := o.orderRepository.FindAllOrdersByOrderGroup(*order.OrderGroup_ID)
	log.Printf("Remaining orders: %#v\n", remainingOrders)
	if new_err != nil || len(remainingOrders) <= 0 {
		return nil, err
	}

	var medicines []*entity.Medicine

	for _, remeiningOrder := range remainingOrders {
		medicines = append(medicines, &remeiningOrder.Medicine)
	}

	return &dto.FindOrderOutputDTO{
		ID:          order.ID,
		Priority:    order.Priority,
		User:        order.User,
		Observation: order.Observation,
		Status:      order.Status,
		Medicine:    medicines,
		UpdatedAt:   order.UpdatedAt,
		CreatedAt:   order.CreatedAt,
		Responsible: order.Responsible,
		Pyxis_ID:    order.Pyxis_ID,
	}, nil
}

func (o *OrderUseCase) UpdateOrder(input *dto.UpdateOrderInputDTO) (*dto.UpdateOrderOutputDTO, error) {
	var responsibleUser *entity.User
	var userErr error
	if input.Responsible_ID != nil {
		responsibleUser, userErr = o.userRepository.FindUserById(*input.Responsible_ID)
		if userErr != nil {
			return nil, userErr
		}
	}

	res, err := o.orderRepository.FindAllOrdersByOrderGroup(input.Order_ID)
	if err != nil || len(res) <= 0 {
		return nil, err
	}

	output := &dto.UpdateOrderOutputDTO{
		Order_ID:    input.Order_ID,
		User:        res[0].User,
		Responsible: responsibleUser,
	}
	for i, order := range res {
		if input.Priority != nil {
			order.Priority = *input.Priority
		}
		order.Observation = input.Observation
		// TODO: change status to pointer
		if input.Status != nil {
			order.Status = *input.Status
		}
		order.Responsible_ID = input.Responsible_ID

		updatedOrder, update_err := o.orderRepository.UpdateOrder(order)

		if update_err != nil {
			return nil, update_err
		}

		output.Medicines = append(output.Medicines, &res[i].Medicine)

		if i == len(res)-1 {
			output.CreatedAt = updatedOrder.CreatedAt
			output.UpdatedAt = updatedOrder.UpdatedAt
			output.Status = updatedOrder.Status
			output.Observation = &updatedOrder.Status
			output.Priority = updatedOrder.Priority
		}
	}

	return output, nil
}

func (o *OrderUseCase) DeleteOrder(id string) error {
	order, err := o.orderRepository.FindOrderById(id)
	if err != nil {
		return err
	}
	return o.orderRepository.DeleteOrder(order.ID)
}
