package com.android.quieromas.adapter;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.quieromas.R;
import com.android.quieromas.fragment.PlanRecipesFragment;
import com.android.quieromas.model.receta.Receta;

import java.util.List;


public class MyPlanRecipesRecyclerViewAdapter extends RecyclerView.Adapter<MyPlanRecipesRecyclerViewAdapter.ViewHolder> {

    private final List<Receta> mValues;
    private final PlanRecipesFragment.OnListFragmentInteractionListener mListener;

    public MyPlanRecipesRecyclerViewAdapter(List<Receta> items, PlanRecipesFragment.OnListFragmentInteractionListener listener) {
        mValues = items;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(final ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.fragment_recipe_item, parent, false);

        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        holder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != mListener) {
                    // Notify the active callbacks interface (the activity, if the
                    // fragment is attached to one) that an item has been selected.
                    mListener.onListFragmentInteraction(holder.mItem);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final TextView txtMeal;
        public final TextView txtTitle;

        public Receta mItem;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            txtMeal = (TextView) view.findViewById(R.id.txt_recipe_meal);
            txtTitle = (TextView) view.findViewById(R.id.txt_recipe_title);
        }

        @Override
        public String toString() {
            return super.toString() + " '" + txtTitle.getText() + "'";
        }
    }
}