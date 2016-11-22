package io.github.azuldigital;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.Layout;
import android.text.format.DateFormat;
import android.text.format.Formatter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Created by mike on 10/11/16.
 */

public final class BillsAdapter extends RecyclerView.Adapter<BillsAdapter.BillHolder> {

    private Context mContext;
    private LayoutInflater mInflater;
    private ArrayList<Bill> mBill;

    public static class BillHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        private ImageView mItemImage;
        private TextView mItemDate;
        private TextView mItemPlate;
        private Bill mBill;

        private static final String BILL_KEY = "BILL";

        public BillHolder(View v) {
            super(v);

            mItemImage = (ImageView) v.findViewById(R.id.bill_list_thumbnail);
            mItemDate = (TextView) v.findViewById(R.id.bill_list_detail);
            mItemPlate = (TextView) v.findViewById(R.id.bill_list_title);
            v.setOnClickListener(this);
        }

        //5
        @Override
        public void onClick(View v) {
            Log.d("RecyclerView", "CLICK!");
        }

        public void bindBill(Bill bill) {

        Long epochTime = bill.getTimeBill();
        Date newDate = new Date(epochTime);
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        format.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
        String formatted = format.format(newDate);
            mBill = bill;
            mItemImage.setImageResource(R.mipmap.ic_launcher);
            mItemDate.setText(formatted);
            mItemPlate.setText(bill.getPlate());
        }
    }


    public BillsAdapter(ArrayList<Bill> bills) {
        mBill = bills;
    }

    @Override
    public BillsAdapter.BillHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View inflatedView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.list_item_bill, parent, false);
        return new BillHolder(inflatedView);
    }

    @Override
    public void onBindViewHolder(BillsAdapter.BillHolder holder, int position) {
        Bill itemBill = mBill.get(position);
        holder.bindBill(itemBill);
    }

    @Override
    public int getItemCount() {
        return mBill.size();
    }
}

//mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//        View rowView = mInflater.inflate(R.layout.list_item_bill, viewGroup, false);
//
//        TextView titleTextView =
//        (TextView) rowView.findViewById(R.id.bill_list_title);
//
//        TextView detailTextView =
//        (TextView) rowView.findViewById(R.id.bill_list_detail);
//
//        ImageView thumbnailImageView =
//        (ImageView) rowView.findViewById(R.id.bill_list_thumbnail);
//
//        Bill bill = (Bill) getItem(position);
//
//        Long epochTime = bill.getTimeBill();
//        Date newDate = new Date(epochTime);
//        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
//        format.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
//        String formatted = format.format(newDate);
//
//        thumbnailImageView.setImageResource(R.mipmap.ic_launcher);
//        titleTextView.setText(bill.getPlate());
//        detailTextView.setText(formatted);