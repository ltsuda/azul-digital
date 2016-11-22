package io.github.azuldigital;

public final class ComposeEmail {

    public String destination, from, subject, body;

    ComposeEmail() {

    }

    //Getters
    public String getDestination() {
        return "contato@emdec.com.br";
    }

    public String getFrom() {
        return from;
    }

    public String getSubject() {
        return subject;
    }

    public String getBody() {
        return body;
    }

    //Setters
    public void setDestination(String destination) {
        this.destination = destination;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public void setSubject(int reason, String plate) {
        if (reason == 0) {
            this.subject = "Não há tickets para este veículo";
        } else if (reason == 1) {
            this.subject = "Placa " + plate + " não encontrada";
        } else if (reason == 2) {
            this.subject = "Ticket inválido";
        }
    }

    public void setBody(int reason, Car car, String plate, String address) {
        if (reason == 1) {
            this.body = "- Local: " + address + "\n- Placa: " + plate;
        } else if (reason == 2 || reason == 0) {
            this.body = "- Local: " + address + "\n- Placa: " + plate + "\n- Marca: " + car.getBrand()
                    + "\n- Modelo: " + car.getModel() + "\n- Cor: " + car.getColor();
        }
    }
}