package repository

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"time"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	cacheError "github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/errors"
	"github.com/redis/go-redis/v9"
)

type MedicineRepositoryRedis struct {
	redis *redis.Client
}

func NewMedicineRepositoryRedis(redis_connection *redis.Client) *MedicineRepositoryRedis {
	return &MedicineRepositoryRedis{redis: redis_connection}
}

func (r *MedicineRepositoryRedis) expirationRule() time.Duration {
	return 30 * time.Minute
}

func (r *MedicineRepositoryRedis) FindMedicinesFromPyxis(ctx context.Context, pyxis_id string) ([]*entity.Medicine, error) {
	val, err := r.redis.Get(ctx, pyxis_id).Result()
	if err != nil {
		switch {
		case errors.Is(err, redis.Nil):
			return nil, cacheError.KeyNil
		default:
			return nil, err
		}
	}

	// Verificar se o valor recuperado está no formato esperado
	var retrievedMedicines []*entity.Medicine
	err = json.Unmarshal([]byte(val), &retrievedMedicines)

	if err != nil {
		log.Printf("Valor na chave errado, deletando chave. Erro: %v\n", err)
		err = r.redis.Del(ctx, pyxis_id).Err()
		if err != nil {
			log.Printf("Unable to delete key: %s\n", err.Error())
			return nil, cacheError.UnableToDeleteKey
		}
		return nil, cacheError.WrongValue
	}

	if retrievedMedicines == nil || len(retrievedMedicines) <= 0 {
		return nil, cacheError.KeyNil
	}

	return retrievedMedicines, nil
}

func (r *MedicineRepositoryRedis) InsertMedicinesPyxis(ctx context.Context, pyxis_id string, medicines []*entity.Medicine) error {
	medicinesJson, err := json.Marshal(medicines)
	if err != nil {
		return err
	}

	expirationTime := r.expirationRule()

	err = r.redis.Set(ctx, pyxis_id, medicinesJson, expirationTime).Err()
	if err != nil {
		return err
	}

	return nil
}

func (r *MedicineRepositoryRedis) RemoveMedicinesPyxis(ctx context.Context, pyxis_id string) error {
	err := r.redis.Del(ctx, pyxis_id).Err()

	return err
}
