package io.github.azuldigital;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;

import java.util.List;
import java.util.Locale;

public final class MapsActivity extends FragmentActivity implements OnMapReadyCallback, OnClickListener {

    private GoogleMap mMap;
    private TextView address;
    private String plate;
    private int reason;
    private Car car;
    private String fiscal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        plate = getIntent().getStringExtra("plate");
        reason = getIntent().getIntExtra("reason", -1);
        fiscal = getIntent().getStringExtra("fiscaluser");

        Bundle extras = getIntent().getExtras();

        if (extras != null) {
            if (getIntent().getSerializableExtra("car") != null){
                car = (Car) getIntent().getSerializableExtra("car");
            }
        }

        findViewById(R.id.next_button).setOnClickListener(this);

        address = (TextView) findViewById(R.id.streetAddress);
        ImageView marker = (ImageView) findViewById(R.id.markerImage);
        marker.setImageResource(R.drawable.annotation_xhdpi);
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        mMap.setMyLocationEnabled(true);
        mMap.setOnCameraIdleListener(new GoogleMap.OnCameraIdleListener() {
            @Override
            public void onCameraIdle() {
                LatLng position = mMap.getCameraPosition().target;
                getAddress(position);
            }
        });
    }

    public void getAddress(LatLng position) {

        try {
            Geocoder geo = new Geocoder(MapsActivity.this.getApplicationContext(), Locale.getDefault());
            List<Address> addresses = geo.getFromLocation(position.latitude, position.longitude, 1);
            if (addresses.isEmpty()) {
                address.setText(R.string.wait_address);
            } else {
                if (addresses.size() > 0) {
                    System.out.println(addresses.get(0).getAddressLine(0) + ", " + addresses.get(0).getLocality());
                    address.setText(addresses.get(0).getAddressLine(0) + ", " + addresses.get(0).getLocality());
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace(); // getFromLocation() may sometimes fail
        }
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.next_button) {
            Intent intent = new Intent(this, PhotoActivity.class);
            intent.putExtra("map_address", address.getText().toString());
            intent.putExtra("plate", plate);
            intent.putExtra("reason", reason);
            intent.putExtra("fiscaluser", fiscal);
            intent.putExtra("car", car);
            startActivity(intent);
        }
    }
}
