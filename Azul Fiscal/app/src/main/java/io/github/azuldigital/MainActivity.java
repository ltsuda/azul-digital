package io.github.azuldigital;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public final class MainActivity extends AppCompatActivity {

    private FirebaseAuth.AuthStateListener authListener;
    private FirebaseAuth auth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        auth = FirebaseAuth.getInstance();

        authListener = new FirebaseAuth.AuthStateListener() {
            @Override
            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
                FirebaseUser user = firebaseAuth.getCurrentUser();
                if (user != null) {
                    startActivity(new Intent(MainActivity.this, HomeActivity.class));
                }
            }
        };
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        moveTaskToBack(true);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public void onStart() {
        super.onStart();
        auth.addAuthStateListener(authListener);
    }

    @Override
    public void onStop() {
        super.onStop();
        if (authListener != null) {
            auth.removeAuthStateListener(authListener);
        }
    }

    //-----------------------------------------------------------Signin Code-------------------------------------------------------

    public void signin(View v) {
        boolean internet = isConnected();

        if (internet) {

            //get text fields
            EditText email = (EditText) findViewById(R.id.email);
            EditText password = (EditText) findViewById(R.id.password);

            //get data from text fields
            String userEmail = email.getText().toString();
            String userPassword = password.getText().toString();

            //check if the fields are empty
            if (TextUtils.isEmpty(userEmail)) {
                Toast.makeText(this, "Por favor, insira o email.", Toast.LENGTH_LONG).show();
                return;
            }

            if (TextUtils.isEmpty(userPassword)) {
                Toast.makeText(this, "Por favor, insira a senha.", Toast.LENGTH_LONG).show();
                return;
            }

            //instantiate progress dialog
            final ProgressDialog progressDialog = new ProgressDialog(MainActivity.this);

            //Show waiting dialog box until user is registered
            progressDialog.setMessage("Autenticando...");
            progressDialog.show();

            //FirebaseAuth instance
            FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();

            //logging in the user
            firebaseAuth.signInWithEmailAndPassword(userEmail, userPassword)
                    .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            progressDialog.dismiss();
                            //if the task is successfull
                            if (task.isSuccessful()) {
                                //start the profile activity
                                Toast.makeText(MainActivity.this, "Sucesso!", Toast.LENGTH_LONG).show();
                                finish();
                                startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                            } else {
                                Toast.makeText(MainActivity.this, "Credenciais Inválidas.", Toast.LENGTH_LONG).show();
                            }
                        }
                    });
        }
        else {
            Toast.makeText(this,"Sem conexão com a internet.",Toast.LENGTH_LONG).show();

            //Hide keyboard
            InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    //-----------------------------------------------------------Conection Code-------------------------------------------------------

    public boolean isConnected() {
        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();

        return netInfo != null && netInfo.isConnectedOrConnecting();
    }
}