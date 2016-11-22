package io.github.azuldigital;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public final class SearchActivity extends AppCompatActivity implements View.OnClickListener {

    private TextView status;
    private TextView remaintime;
    private FirebaseDatabase database_search = FirebaseDatabase.getInstance();
    private  DatabaseReference myRef_search = database_search.getReference();
    private String status_aux;
    private String carPlate;
    private Long timestamp, timestamp1970long, hours, minute;
    private Car car;
    private  Ticket ticket;
    private String fiscal;
    private  ValueEventListener postListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        findViewById(R.id.email_search).setOnClickListener(this);

        String userid = getIntent().getStringExtra("fiscalID");
        car = (Car) getIntent().getSerializableExtra("Car");
        ticket = (Ticket) getIntent().getSerializableExtra("Ticket");
        carPlate = getIntent().getStringExtra("CarPlate");
        fiscal = getIntent().getStringExtra("fiscaluser");

        TextView brand = (TextView) findViewById(R.id.carbrand);
        TextView color = (TextView) findViewById(R.id.carcolor);
        TextView model = (TextView) findViewById(R.id.carmodel);
        TextView plate = (TextView) findViewById(R.id.carplate);
        status = (TextView) findViewById(R.id.statusplate);

        brand.setText(car.getBrand());
        color.setText(car.getColor());
        model.setText(car.getModel());
        plate.setText(carPlate);

        Double timestamp1970 = ticket.getTimeStampSince1970() / 1000;
        timestamp1970long = timestamp1970.longValue();

        // Read timestamp from firebase to calculate if ticket is valid
        postListener = new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {

                timestamp = (Long) snapshot.getValue() / 1000;
                System.out.println(timestamp);
                Long time = timestamp - timestamp1970long;
                System.out.println(time);

                if (time > 60){
                    status_aux = "Invalido";
                    status.setTextColor(Color.rgb(255,0,0));
                    status.setText(status_aux);

                    //Show email button
                    Button emailhome = (Button)findViewById(R.id.email_search);
                    emailhome.setVisibility(View.VISIBLE);

                    hours = 0L;
                    minute = 0L;

                }
                else {
                    status_aux = "Valido";
                    status.setTextColor(Color.rgb(0,128,0));
                    status.setText(status_aux);

                    Long timetogo = 60 - time;

                    hours = timetogo / 3600;
                    minute = (timetogo % 3600) / 60;
                }

                String hour = String.format("%02d:%02d",hours,minute);

                remaintime = (TextView)findViewById(R.id.tempo_restante);
                remaintime.setText(hour);
            }

            @Override
            public void onCancelled(DatabaseError firebaseError) {
                Toast.makeText(SearchActivity.this, "Erro ao ler timestamp", Toast.LENGTH_LONG).show();
            }
        };
        myRef_search.child("timeStamps").child("serverTime").addValueEventListener(postListener);
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent back = new Intent(SearchActivity.this, HomeActivity.class);
        back.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(back);
        myRef_search.child("timeStamps").child("serverTime").removeEventListener(postListener);
    }

    public void backpage(View v) {
        Intent back = new Intent(SearchActivity.this, HomeActivity.class);
        back.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(back);
        myRef_search.child("timeStamps").child("serverTime").removeEventListener(postListener);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.email_search) {
            //Checks if location is enable, if not, open activation screen
            LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
            boolean GPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

            if(!GPSEnabled){
                AlertDialog.Builder builder = new AlertDialog.Builder(
                        SearchActivity.this);
                builder.setTitle("Localização desativada");
                builder.setMessage("É necessário que a Localização esteja habilitada para utilização do aplicativo.");
                builder.setNegativeButton("Cancelar",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,
                                                int which) {
                            }
                        });
                builder.setPositiveButton("Configuração",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,
                                                int which) {
                                startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
                            }
                        });
                builder.show();
            }
            else {
                Intent intent = new Intent(this, MapsActivity.class);
                intent.putExtra("ticket", ticket);
                intent.putExtra("car", car);
                intent.putExtra("plate", carPlate);
                int reason = 2;
                intent.putExtra("reason", reason);
                intent.putExtra("fiscaluser", fiscal);
                startActivity(intent);
                myRef_search.child("timeStamps").child("serverTime").removeEventListener(postListener);
            }
        }
    }
}