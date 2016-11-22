package io.github.azuldigital;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

public final class EmailActivity extends AppCompatActivity implements View.OnClickListener {

    private TextView subject;
    private TextView body;
    private ImageView previewPhoto;
    private Button send;
    private File image;
    private Bitmap bitmap;
    private String address, mapAddress, plate, fiscal;
    private Car car;
    private Ticket ticket;
    private int reason;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_email);

        ComposeEmail email = new ComposeEmail();

        Bundle extras = getIntent().getExtras();

        if (extras != null) {
            if (getIntent().getStringExtra("map_address") != null){
                mapAddress = getIntent().getStringExtra("map_address");
            }
            if (getIntent().getStringExtra("plate") != null){
                plate = getIntent().getStringExtra("plate");
            }
            if (getIntent().getSerializableExtra("car") != null){
                car = (Car) getIntent().getSerializableExtra("car");
            }
            if (getIntent().getSerializableExtra("ticket") != null){
                ticket = (Ticket) getIntent().getSerializableExtra("ticket");
            }
            if (getIntent().getIntExtra("reason", 0) != 0) {
                reason = getIntent().getIntExtra("reason", 0);
            }
            if (getIntent().getStringExtra("fiscaluser") != null) {
                fiscal = getIntent().getStringExtra("fiscaluser");
            }
        }

        File local = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), "MyCameraApp");
        image = new File(local.getPath() + local.separator + "IMG_PLATE" + ".jpg");
        BitmapFactory.Options bmOptions = new BitmapFactory.Options();
        bitmap = BitmapFactory.decodeFile(image.getPath(), bmOptions);

        TextView destination = (TextView) findViewById(R.id.destinationText);
        TextView from = (TextView) findViewById(R.id.fromText);
        subject = (TextView) findViewById(R.id.subText);
        body = (TextView) findViewById(R.id.bodyText);
        previewPhoto = (ImageView) findViewById(R.id.photoImageView);
        send = (Button) findViewById(R.id.send_email);

        //Compose email
        destination.setText(email.getDestination());
        email.setFrom(fiscal);
        from.setText(email.getFrom());
        email.setSubject(reason, plate);
        subject.setText(email.getSubject());
        email.setBody(reason, car, plate, mapAddress);
        body.setText(email.getBody());

        findViewById(R.id.send_email).setOnClickListener(this);

        setImageView();

    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.send_email) {
            Intent i = new Intent(Intent.ACTION_SEND);
            i.setType("message/rfc822");
            i.putExtra(Intent.EXTRA_EMAIL  , new String[]{"leonardo.tsuda@gmail.com"});
            i.putExtra(Intent.EXTRA_SUBJECT, subject.getText());
            i.putExtra(Intent.EXTRA_TEXT   , body.getText());
            i.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(image));
            try {
                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivityForResult(Intent.createChooser(i, "Enviando mail..."), 0);
            } catch (android.content.ActivityNotFoundException ex) {
                Toast.makeText(EmailActivity.this, "Não há clientes de email instalado.", Toast.LENGTH_SHORT).show();
            }
        }
    }
    @Override
        public void onActivityResult(int requestCode, int resultCode, Intent data) {
            if (requestCode == 0) {
                Intent home = new Intent(this, HomeActivity.class);
                home.putExtra("plate", plate);
                home.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(home);
            }
    }

    protected void setImageView() {
        DisplayMetrics metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        bitmap = Bitmap.createScaledBitmap(bitmap, metrics.widthPixels, metrics.widthPixels,true);
        previewPhoto.setRotation(previewPhoto.getRotation());
        previewPhoto.setImageBitmap(bitmap);
    }
}