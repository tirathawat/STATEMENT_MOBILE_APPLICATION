package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/mitchellh/mapstructure"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

type Statement struct {
	ID     string  `json:"id"`
	Date   string  `json:"date"`
	Amount float32 `json:"amount"`
	Detail string  `json:"detail"`
}

type App struct {
	Router *mux.Router
	client *firestore.Client
	ctx    context.Context
}

func main() {
	godotenv.Load()
	route := App{}
	route.Init()
	route.Run()
}

func (route *App) Init() {

	route.ctx = context.Background()

	sa := option.WithCredentialsFile("serviceAccountKey.json")
	app, err := firebase.NewApp(route.ctx, nil, sa)
	if err != nil {
		log.Fatalln(err)
	}

	route.client, err = app.Firestore(route.ctx)
	if err != nil {
		log.Fatalln(err)
	}
	route.Router = mux.NewRouter()
	route.initializeRoutes()
	fmt.Println("Successfully connected at port : " + route.GetPort())
}

func (route *App) GetPort() string {
	var port = os.Getenv("MyPort")
	if port == "" {
		port = "5000"
	}
	return ":" + port
}

func (route *App) Run() {
	log.Fatal(http.ListenAndServe(route.GetPort(), route.Router))
}

func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	response, _ := json.Marshal(payload)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}

func (route *App) initializeRoutes() {
	route.Router.HandleFunc("/", route.Home).Methods("GET")
	route.Router.HandleFunc("/read", route.ReadAllStatement).Methods("GET")
	route.Router.HandleFunc("/create", route.CreateStatement).Methods("POST")
	route.Router.HandleFunc("/update/{id}", route.UpdateStatement).Methods("PUT")
	route.Router.HandleFunc("/delete/{id}", route.DeleteStatement).Methods("DELETE")
}

func (route *App) Home(w http.ResponseWriter, r *http.Request) {
	respondWithJSON(w, http.StatusOK, "Hello")
}

func (route *App) ReadAllStatement(w http.ResponseWriter, r *http.Request) {
	StatementsData := []Statement{}

	iter := route.client.Collection("statements").Documents(route.ctx)
	for {
		StatementData := Statement{}

		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			respondWithJSON(w, http.StatusInternalServerError, "Something wrong, please try again.")
		}
		mapstructure.Decode(doc.Data(), &StatementData)

		StatementsData = append(StatementsData, StatementData)
	}
	respondWithJSON(w, http.StatusOK, StatementsData)
}

func (route *App) CreateStatement(w http.ResponseWriter, r *http.Request) {
	uid, errUid := uuid.NewUUID()
	splitID := strings.Split(uid.String(), "-")
	id := splitID[0] + splitID[1] + splitID[2] + splitID[3] + splitID[4]

	StatementData := Statement{}

	StatementData.ID = id

	Decoder := json.NewDecoder(r.Body)
	err := Decoder.Decode(&StatementData)

	if err != nil || errUid != nil {
		log.Printf("error: %s", err)
	}

	_, _, err = route.client.Collection("statements").Add(route.ctx, StatementData)
	if err != nil {
		log.Printf("An error has occurred: %s", err)
	}

	respondWithJSON(w, http.StatusCreated, "Create success!")
}

func (route *App) UpdateStatement(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	paramsID := params["id"]

	StatementData := Statement{}

	Decoder := json.NewDecoder(r.Body)
	err := Decoder.Decode(&StatementData)
	if err != nil {
		log.Printf("error: %s", err)
	}

	var docID string
	StatementData.ID = paramsID

	iter := route.client.Collection("statements").Where("ID", "==", paramsID).Documents(route.ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		docID = doc.Ref.ID
	}

	_, err = route.client.Collection("statements").Doc(docID).Set(route.ctx, StatementData)
	if err != nil {
		log.Printf("An error has occurred: %s", err)
	}

	respondWithJSON(w, http.StatusCreated, "Update success!")
}

func (route *App) DeleteStatement(w http.ResponseWriter, r *http.Request) {

	params := mux.Vars(r)
	paramsID := params["id"]

	var docID string

	iter := route.client.Collection("statements").Where("ID", "==", paramsID).Documents(route.ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		docID = doc.Ref.ID
	}

	_, err := route.client.Collection("statements").Doc(docID).Delete(route.ctx)
	if err != nil {
		log.Printf("An error has occurred: %s", err)
	}

	respondWithJSON(w, http.StatusOK, "Delete success !")
}
