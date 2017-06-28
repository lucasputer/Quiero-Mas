package com.android.quieromas.adapter;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.android.quieromas.R;
import com.android.quieromas.activity.RecipeActivity;
import com.android.quieromas.fragment.FavoriteRecipesFragment;
import com.android.quieromas.model.DummyContent;
import com.android.quieromas.model.receta.RecipeStepElement;

import java.util.List;

/**
 * Created by lucas on 28/6/17.
 */

public class RecipeRecyclerViewAdapter extends RecyclerView.Adapter<RecipeRecyclerViewAdapter.ViewHolder> {

    private final List<RecipeStepElement> mValues;
    private final boolean isSteps;


    public RecipeRecyclerViewAdapter(List<RecipeStepElement> items, boolean isSteps) {
        mValues = items;
        this.isSteps = isSteps;
    }

    @Override
    public RecipeRecyclerViewAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.listitem_recipe_steps, parent, false);
        return new RecipeRecyclerViewAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final RecipeRecyclerViewAdapter.ViewHolder holder, int position) {
        holder.mItem = mValues.get(position);
        holder.txtText.setText(mValues.get(position).getText());
        if(isSteps){
            int n = position + 1;
            holder.txtIndicator.setText(Integer.toString(n));
        }else{
            holder.txtIndicator.setText("●");

            if(holder.mItem.getBasicRecipe() != null){

                holder.btnPlus.setVisibility(View.VISIBLE);

                holder.btnPlus.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                    }
                });
            }
        }

    }

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final TextView txtIndicator;
        public final TextView txtText;
        public final Button btnPlus;

        public RecipeStepElement mItem;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            txtText = (TextView) view.findViewById(R.id.recipe_list_steps_step_info);
            txtIndicator = (TextView) view.findViewById(R.id.recipe_list_steps_step_n);
            btnPlus = (Button) view.findViewById(R.id.recipe_list_steps_plus);
        }

        @Override
        public String toString() {
            return "'";
        }
    }
}
