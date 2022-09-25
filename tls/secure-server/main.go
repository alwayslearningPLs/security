package main

import (
  "net/http"
  "log"
)

func main() {
  http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("Content-Type", "text/plain")
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("Mellow"))
  })

  if err := http.ListenAndServeTLS("[::1]:8080", "./cert.pem", "./key.pem", nil); err != nil {
    log.Fatal(err)
  }
}
