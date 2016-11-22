package io.github.azuldigital;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;

import java.util.ArrayList;

public class BillsActivity extends AppCompatActivity {

    private RecyclerView mRecyclerView;
    private LinearLayoutManager mLinearLayoutManager;
    private BillsAdapter mAdapter;
    private ArrayList<Bill> bills = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bills);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle("Histórico diário de multas");

        mRecyclerView = (RecyclerView) findViewById(R.id.recyclerView);
        mLinearLayoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(mLinearLayoutManager);

        SeparatorDecoration decoration = new SeparatorDecoration(this, Color.LTGRAY, 1.0f);
        mRecyclerView.addItemDecoration(decoration);

        Bundle extras = getIntent().getExtras();

        if (extras != null) {
            if (getIntent().getExtras() != null) {
                bills = getIntent().getParcelableArrayListExtra("Bills");
            }
        }

        mAdapter = new BillsAdapter(bills);
        mRecyclerView.setAdapter(mAdapter);
    }
}
