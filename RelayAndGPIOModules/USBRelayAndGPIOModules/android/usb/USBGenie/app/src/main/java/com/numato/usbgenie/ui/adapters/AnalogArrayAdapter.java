/*
Copyright [2015] [Numato Systems Private Limited]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package com.numato.usbgenie.ui.adapters;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.norbsoft.typefacehelper.TypefaceHelper;
import com.numato.usbgenie.BuildConfig;
import com.numato.usbgenie.R;
import com.numato.usbgenie.business.AppConstant;
import com.numato.usbgenie.business.GeneralSettings;
import com.numato.usbgenie.model.devices.Analog;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Analog Input Data array adapter
 */
public class AnalogArrayAdapter extends ArrayAdapter<Analog> {


    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------

    public class ViewHolder {

        @BindView(R.id.analogRowImage)
        public ImageView rowImage;
        @BindView(R.id.analogRowText)
        public TextView rowText;
        @BindView(R.id.analogrowResultText)
        public TextView analogrowResultText;
        @BindView(R.id.analogrowResultPercentage)
        public TextView analogrowResultPercentage;
        @BindView(R.id.analogRowProgressBar)
        public ProgressBar rowProgressBar;

        public ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }

    // ------------------------------------------------------------------------
    // STATIC FIELDS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // STATIC METHODS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // FIELDS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    public AnalogArrayAdapter(Context context, List<Analog> objects) {
        super(context, R.layout.analog_list_row, new ArrayList<Analog>(objects));
    }
    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------

    public View getView(int position, View convertView, ViewGroup parent) {

        View rowView = convertView;
        // reuse views
        if (rowView == null) {
            LayoutInflater inflater = LayoutInflater.from(getContext());
            rowView = inflater.inflate(R.layout.analog_list_row, parent, false);
            TypefaceHelper.typeface(rowView);
            // configure view holder
            ViewHolder viewHolder = new ViewHolder(rowView);
            rowView.setTag(viewHolder);
        }


        ViewHolder holder = (ViewHolder) rowView.getTag();
        final Analog analog = getItem(position);
        int analogvalue = analog.getAnalog();

        holder.rowText.setText(getContext().getString(R.string.lbl_analog) + " " + Integer.toString(analog.getNumber()));
        holder.analogrowResultText.setText(Integer.toString(analogvalue) + "/" + AppConstant.MAX_NR_BITS);
        holder.analogrowResultPercentage.setText(Integer.toString((int) ((analogvalue / (float) AppConstant.MAX_NR_BITS) * 100)) + "%");
        holder.rowProgressBar.setMax(1024);
        holder.rowProgressBar.setProgress(analogvalue);

        return rowView;
    }
}
