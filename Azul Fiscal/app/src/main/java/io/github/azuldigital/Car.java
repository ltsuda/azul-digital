package io.github.azuldigital;

import java.io.Serializable;

public final class Car implements Serializable {
    // variables on Ticket
    public String brand, color, model, userID;
    public Ticket ticket;

    public Car(String brand, String color, String model, String userID) {
        /*Blank default constructor essential for Firebase*/
        this.brand = brand;
        this.color = color;
        this.model = model;
        this.userID = userID;
    }

    public  Car() {

    }

    //Getters
    public String getBrand(){
        return brand;
    }

    public String getColor(){
        return color;
    }

    public String getModel(){
        return model;
    }

    public String getUserID(){
        return userID;
    }

    public Ticket getTicket() { return ticket; }

    //Setters
    public void set(String brand) {
        this.brand = brand;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public void setUserID(String userID) {
        this.model = model;
    }

    public  void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

}