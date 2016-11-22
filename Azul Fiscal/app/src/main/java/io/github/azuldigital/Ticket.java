package io.github.azuldigital;

import java.io.Serializable;

public final class Ticket implements Serializable {
    // variables on Ticket
    public String address, name;
    public Boolean isPaid;
    public Double timeStampSince1970, value;

    public  Ticket() {

    }

    public Ticket(String address, Boolean isPaid, String name, Double timeStampSince1970, Double value) {
        /*Blank default constructor essential for Firebase*/
        this.address = address;
        this.isPaid = isPaid;
        this.name = name;
        this.timeStampSince1970 = timeStampSince1970;
        this.value = value;
    }

    //Getters
    public String getAddress(){
        return address;
    }

    public Boolean getIsPaid(){
        return isPaid;
    }

    public String getName(){
        return name;
    }

    public Double getTimeStampSince1970(){
        return timeStampSince1970;
    }

    public Double getValue(){
        return value;
    }

    //Setters
    public void setAddress(String address) {
        this.address = address;
    }

    public void setIsPaid(Boolean isPaid) {
        this.isPaid = isPaid;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTimeStampSince1970(Double timeStampSince1970) {
        this.timeStampSince1970 = timeStampSince1970;
    }

    public void setValue(Double value) {
        this.value = value;
    }

}