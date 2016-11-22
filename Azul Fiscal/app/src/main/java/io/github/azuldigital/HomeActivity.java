package io.github.azuldigital;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ServerValue;
import com.google.firebase.database.ValueEventListener;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class HomeActivity extends AppCompatActivity implements View.OnClickListener {

    private static final String TAG = "HomeActivity";
    private Intent intent;
    private FirebaseAuth firebaseAuth;
    private FirebaseDatabase database = FirebaseDatabase.getInstance();
    private DatabaseReference myRef = database.getReference();
    private String fireuser, formatted_server, formatted_ticket;
    private static final int RC_OCR_CAPTURE = 9003;
    private EditText plate;
    private static final String regex = "[^a-zA-Z0-9]";
    private Matcher customMatcher;
    private TextView statusmessage;
    private int reason;
    private FirebaseUser firebaseuser;
    private String plateBill;
    private Long timestamp_home, timestamp1970long_ticket;
    private Car car;
    ProgressDialog progressDialog;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        progressDialog = new ProgressDialog(HomeActivity.this);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        Bundle extras = getIntent().getExtras();

        final ProgressDialog progressDialog = new ProgressDialog(HomeActivity.this);

        if (extras != null) {
            if (getIntent().getStringExtra("plate") != null) {
                plateBill = getIntent().getStringExtra("plate");
                progressDialog.setMessage("Salvando multa...");
                progressDialog.show();
                try {
                    String autoKey = database.getReference().child("billHistory").push().getKey();
                    Map<String, Object> value = new HashMap<>();
                    value.put("plate", plateBill);
                    value.put("timeBill", ServerValue.TIMESTAMP);
                    database.getReference().child("billHistory").child(autoKey).setValue(value);
                    progressDialog.dismiss();
                } catch (android.content.ActivityNotFoundException e) {
                    Toast.makeText(HomeActivity.this, "Multa não salva, verificar se email foi enviado.", Toast.LENGTH_SHORT).show();
                    progressDialog.dismiss();
                }
            }
        }

        plate = (EditText) findViewById(R.id.plate);
        findViewById(R.id.cameraButton).setOnClickListener(this);
        findViewById(R.id.email_home).setOnClickListener(this);

        //initializing Firebase user
        firebaseAuth = FirebaseAuth.getInstance();

        //check if the user is not logged in
        if (firebaseAuth.getCurrentUser() == null) {
            finish();
            startActivity(new Intent(this, MainActivity.class));
        }

        //Get Firebase logged in user
        firebaseuser = firebaseAuth.getCurrentUser();
        fireuser = firebaseuser.getUid();

        //set email address on screen for the current logged in user
        TextView emailuser;
        emailuser = (TextView) findViewById(R.id.EmailUser);
        emailuser.setText(firebaseuser.getEmail());

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // action with ID action_refresh was selected
            case R.id.history_button:

                progressDialog.setMessage("Buscando multas");
                progressDialog.show();

                myRef.child("billHistory").addListenerForSingleValueEvent(
                        new ValueEventListener() {
                            @Override
                            public void onDataChange(DataSnapshot dataSnapshot) {

                                // Initialize class object
                                final ArrayList<Bill> bills = new ArrayList<Bill>();

                                for (DataSnapshot billSnapshot: dataSnapshot.getChildren()) {
                                    Long timeStamp =  (billSnapshot.getValue(Bill.class).getTimeBill());
                                    String plate = (billSnapshot.getValue(Bill.class).getPlate());
                                    Bill bill = new Bill(plate, timeStamp);
                                    bills.add(bill);
                                }

                                if (!bills.isEmpty()) {
                                    progressDialog.dismiss();
                                    Intent intent = new Intent(HomeActivity.this, BillsActivity.class);
                                    Bundle bundle = new Bundle();
                                    bundle.putParcelableArrayList("Bills", bills);
                                    intent.putExtras(bundle);
                                    startActivity(intent);

                                } else {
                                    progressDialog.dismiss();
                                    Toast.makeText(HomeActivity.this,"Não há multas aplicadas", Toast.LENGTH_LONG).show();
                                }
                            }

                            @Override
                            public void onCancelled(DatabaseError databaseError) {
                                Toast.makeText(HomeActivity.this, databaseError.toException().toString(), Toast.LENGTH_LONG).show();
                            }
                        });
                break;
            default:
                break;
        }

        return true;
    }


    public void logout(View v) {
        //logout user
        firebaseAuth.signOut();
        finish();
        startActivity(new Intent(this, MainActivity.class));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        moveTaskToBack(true);
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if(requestCode == RC_OCR_CAPTURE) {
            if (resultCode == CommonStatusCodes.SUCCESS) {
                if (data != null) {
                    String text = data.getStringExtra(OcrCaptureActivity.TextBlockObject);
                    plate.setText(formatPlate(text));
                } else {
                    statusmessage.setText(R.string.ocr_failure);
                }
            } else {
                statusmessage.setText(String.format(getString(R.string.ocr_error),
                        CommonStatusCodes.getStatusCodeString(resultCode)));
            }
            statusmessage = (TextView) findViewById(R.id.statusmessage);
        }
        else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    private String formatPlate(String plate) {
        String formattedPlate;
        formattedPlate = plate.replaceAll(regex, "");
        System.out.println(formattedPlate);
        return formattedPlate;
    }

    //-----------------------------------------------------------Search Plate Code----------------------------------------------------

    public void searchplate(View v) {

        Pattern pattern = Pattern.compile("^[a-zA-Z]{3}[0-9]{4}$");

        System.out.println(pattern);
        //get text fields
        EditText plate = (EditText) findViewById(R.id.plate);

        //get data from text fields
        final String userPlate = plate.getText().toString();

        //check if the fields are empty
        if (TextUtils.isEmpty(userPlate)) {
            Toast.makeText(this, "Por favor, insira a placa.", Toast.LENGTH_LONG).show();
            return;
        }

        customMatcher = pattern.matcher(plate.getText().toString());

        if (!customMatcher.matches()) {
            InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);

            Toast.makeText(this, "Por favor, insira a placa com formato ABC1234", Toast.LENGTH_LONG).show();
        } else {
            //Show waiting dialog box until user is registered
            InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);

            progressDialog.setMessage("Buscando placa...");
            progressDialog.show();

            myRef.child("timeStamps").child("serverTime").addListenerForSingleValueEvent(
                    new ValueEventListener() {
                        @Override
                        public void onDataChange(DataSnapshot dataSnapshot) {
                            timestamp_home = (Long) dataSnapshot.getValue();
                            System.out.println(timestamp_home);

                            Date newDate_server = new Date(timestamp_home);
                            SimpleDateFormat format_server = new SimpleDateFormat("dd/MM/yyyy");
                            format_server.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
                            formatted_server = format_server.format(newDate_server);
                            System.out.println(formatted_server);
                        }

                        @Override
                        public void onCancelled(DatabaseError databaseError) {
                            Toast.makeText(HomeActivity.this, databaseError.toException().toString(), Toast.LENGTH_LONG).show();
                        }
                    }
            );

            myRef.child("cars").child(userPlate).addListenerForSingleValueEvent(
                    new ValueEventListener() {
                        @Override
                        public void onDataChange(DataSnapshot dataSnapshot) {
                            // Initialize class object
                            car = dataSnapshot.getValue(Car.class);
                            if (car != null) {

                                final List<Ticket> tickets = new ArrayList<Ticket>();

                                for (DataSnapshot ticketsSnapshot: dataSnapshot.child("ticket").getChildren()) {
                                    String address = (ticketsSnapshot.getValue(Ticket.class).getAddress());
                                    Boolean isPaid = (ticketsSnapshot.getValue(Ticket.class).getIsPaid());
                                    String name = (ticketsSnapshot.getValue(Ticket.class).getName());
                                    Double timeStamp = (ticketsSnapshot.getValue(Ticket.class).getTimeStampSince1970());
                                    Double value = (ticketsSnapshot.getValue(Ticket.class).getValue());
                                    Ticket ticket = new Ticket(address, isPaid, name, timeStamp, value);
                                    tickets.add(ticket);
                                }

                                Ticket ticket_timestamp = tickets.get(tickets.size()-1);
                                Double timestamp1970_ticket = ticket_timestamp.getTimeStampSince1970();
                                timestamp1970long_ticket = timestamp1970_ticket.longValue();
                                System.out.println(timestamp1970long_ticket);

                                Date newDate_ticket = new Date(timestamp1970long_ticket);
                                SimpleDateFormat format_ticket = new SimpleDateFormat("dd/MM/yyyy");
                                format_ticket.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
                                formatted_ticket = format_ticket.format(newDate_ticket);
                                System.out.println(formatted_ticket);

                                if ((!tickets.isEmpty()) && (formatted_server.equals(formatted_ticket))) {
                                    startActivity(new Intent(getApplicationContext(), SearchActivity.class));
                                    progressDialog.dismiss();

                                    intent = new Intent(HomeActivity.this, SearchActivity.class);
                                    intent.putExtra("Car", car);
                                    intent.putExtra("Ticket", tickets.get(tickets.size()-1));
                                    intent.putExtra("CarPlate", userPlate);
                                    intent.putExtra("fiscalID",fireuser);
                                    intent.putExtra("fiscaluser", firebaseuser.getEmail());
                                    startActivity(intent);

                                } else {
                                    progressDialog.dismiss();
                                    //Tickets not found
                                    reason = 0;
                                    Toast.makeText(HomeActivity.this,"Não há tickets para este veículo", Toast.LENGTH_LONG).show();

                                    //Show email button
                                    Button emailhome = (Button)findViewById(R.id.email_home);
                                    emailhome.setVisibility(View.VISIBLE);
                                }

                            }

                            else {
                                EditText plate = (EditText) findViewById(R.id.plate);
                                String userPlate = plate.getText().toString();

                                progressDialog.dismiss();

                                //Plate not found
                                reason = 1;
                                Toast.makeText(HomeActivity.this,"Placa " + userPlate + " não encontrada",Toast.LENGTH_LONG).show();

                                //Hide keyboard
                                InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                                inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);

                                //Show email button
                                Button emailhome = (Button)findViewById(R.id.email_home);
                                emailhome.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onCancelled(DatabaseError databaseError) {
                            Toast.makeText(HomeActivity.this, databaseError.toException().toString(), Toast.LENGTH_LONG).show();
                        }
                    });
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.cameraButton) {
            // launch Ocr capture activity.
            Intent intent = new Intent(this, OcrCaptureActivity.class);
            startActivityForResult(intent, RC_OCR_CAPTURE);
        } else if (v.getId() == R.id.email_home) {

            //Checks if location is enable, if not, open activation screen
            LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
            boolean GPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

            if(!GPSEnabled){
                AlertDialog.Builder builder = new AlertDialog.Builder(
                        HomeActivity.this);
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
                intent.putExtra("plate", plate.getText().toString());
                intent.putExtra("reason", reason);
                intent.putExtra("fiscaluser", firebaseuser.getEmail());
                intent.putExtra("car", car);
                startActivity(intent);
            }
        } else if (v.getId() == R.id.history_button) {

        }
    }
}