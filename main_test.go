package main

import (
	"testing"
)

// Test 1: Addition Test
func TestAdd(t *testing.T) {
	result := Add(2, 3)
	expected := 5
	if result != expected {
		t.Errorf("Add() failed: expected %d, got %d", expected, result)
	}
}

// Test 2: Subtraction Test (Intentional Failure)
func TestSubtract(t *testing.T) {
	result := Subtract(5, 3)
	expected := 1 // Incorrect expectation to simulate failure
	if result != expected {
		t.Errorf("Subtract() failed: expected %d, got %d", expected, result)
	}
}
