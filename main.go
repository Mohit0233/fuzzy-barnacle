package main

import "fmt"

func main() {
	fmt.Println("Go Test Example")
}

// Function to simulate a simple operation
func Add(a, b int) int {
	return a + b
}

// Function that will cause a test failure for demonstration
func Subtract(a, b int) int {
	return a - b
}
