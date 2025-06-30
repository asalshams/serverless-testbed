package main

import (
	"fmt"
	"net/http"
	"strconv"
)

func fib(n int) int {
	if n <= 1 {
		return n
	}
	return fib(n-1) + fib(n-2)
}

func handler(w http.ResponseWriter, r *http.Request) {
	nStr := r.URL.Query().Get("n")
	n, _ := strconv.Atoi(nStr)
	if nStr == "" {
		n = 10
	}
	result := fib(n)
	fmt.Fprintf(w, `{"input": %d, "output": %d}`, n, result)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
