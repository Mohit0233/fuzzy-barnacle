package main

import "fmt"

func main() {
	fmt.Println("Go Test Example")
}

// Add Function to simulate a simple operation
func Add(a, b int) int {
	return a + b
}

// Subtract Function that will cause a test failure for demonstration
func Subtract(a, b int) int {
	return a - b
}
