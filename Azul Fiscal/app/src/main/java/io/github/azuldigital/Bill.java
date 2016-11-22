package io.github.azuldigital;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;
import java.io.StreamCorruptedException;

/**
 * Created by mike on 10/11/16.
 */

public final class Bill implements Parcelable {
    public String plate;
    public Long timeBill;

    public Bill() {
    }

    Bill(String plate, Long timeBill) {
        this.plate = plate;
        this.timeBill = timeBill;
    }

    public Bill(Parcel in) {
        plate = in.readString();
        timeBill = in.readLong();
    }

    //Getters
    public String getPlate(){
        return plate;
    }

    public Long getTimeBill(){
        return timeBill;
    }

    //Setters
    public void setTimeBill(Long timeBill) {
        this.timeBill = timeBill;
    }

    public void setPlate(String plate) {
        this.plate = plate;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(plate);
        parcel.writeLong(timeBill);
    }

    public static final Parcelable.Creator<Bill> CREATOR = new Parcelable.Creator<Bill>() {
        public Bill createFromParcel(Parcel in)
        {
            return new Bill(in);
        }
        public Bill[] newArray(int size)
        {
            return new Bill[size];
        }
    };
}
