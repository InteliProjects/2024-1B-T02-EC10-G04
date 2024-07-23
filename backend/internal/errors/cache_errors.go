package errors

type CacheError string

func (e CacheError) Error() string { return string(e) }

func (CacheError) CacheError() {}

const KeyNil = CacheError("Key doesn't exists")

const WrongValue = CacheError("Value in the wrong format")

const UnableToDeleteKey = CacheError("Unable to delete key")
