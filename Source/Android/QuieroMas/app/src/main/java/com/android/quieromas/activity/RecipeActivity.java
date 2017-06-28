package com.android.quieromas.activity;

import android.content.Intent;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Adapter;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.quieromas.R;
import com.android.quieromas.adapter.MyFavoriteRecipesRecyclerViewAdapter;
import com.android.quieromas.adapter.RecipeRecyclerViewAdapter;
import com.android.quieromas.model.DummyContent;
import com.android.quieromas.model.FirebaseDatabaseKeys;
import com.android.quieromas.model.receta.Ingrediente;
import com.android.quieromas.model.receta.Receta;
import com.android.quieromas.model.receta.RecipeStepElement;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.ListIterator;

public class RecipeActivity extends AuthActivity {

    private Button btnDessert;
    private Button btnNutritionalTip;
    private Button btnDevelopmentTip;
    private Button btnWatch;
    private String recipeName;
    private Receta receta;
    private ImageView imgBackground;
    private String dessertName;
    private TextView txtVariants;
    private TextView txtName;
    private RecyclerView rvSteps;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recipe);
        //Initialize toolbar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);

        toolbar.setTitle("");

        setSupportActionBar(toolbar);
        //Show "back" button
        //getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            recipeName = extras.getString("RECIPE");
            if(extras.containsKey("DESSERT")){
                dessertName = extras.getString("DESSERT");
            }
        }



        DatabaseReference recetasRef = FirebaseDatabase.getInstance().getReference(FirebaseDatabaseKeys.getInstance().RECIPES);
        recetasRef.child("Por Nombre").child(recipeName).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                receta = dataSnapshot.getValue(Receta.class);
                updateUI();
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });

        btnDessert = (Button) findViewById(R.id.recipe_button_dessert);
        imgBackground = (ImageView) findViewById(R.id.img_recipe_image);
        btnWatch = (Button) findViewById(R.id.btn_recipe_watch);
        btnNutritionalTip = (Button) findViewById(R.id.recipe_button_nutritional_tip);
        btnDevelopmentTip = (Button) findViewById(R.id.recipe_button_development_tip);
        txtVariants = (TextView) findViewById(R.id.txt_recipe_variants);
        txtName = (TextView) findViewById(R.id.txt_recipe_name);
        rvSteps = (RecyclerView) findViewById(R.id.recipe_list_steps);

        txtName.setText(recipeName);

        if(dessertName == null){
            btnDessert.setVisibility(View.GONE);
        }else{
            DatabaseReference postresRef = FirebaseDatabase.getInstance().getReference(FirebaseDatabaseKeys.getInstance().DESSERTS);
            postresRef.child(dessertName).addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {
                    final String dessertText = dataSnapshot.getValue(String.class);
                    btnDessert.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            startTipActivity(dessertName,dessertText,"apple");
                        }
                    });
                }

                @Override
                public void onCancelled(DatabaseError databaseError) {

                }
            });
        }


    }

    private void startTipActivity(String title, String text, String drawable){
        Intent intent = new Intent(getApplicationContext(), TipActivity.class);
        intent.putExtra("title",title);
        intent.putExtra("drawable",drawable);
        intent.putExtra("text", text);
        startActivity(intent);
    }

    private void updateUI(){

        btnDevelopmentTip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startTipActivity("Tip de Desarrollo",receta.getTip_desarrollo(),"light_bulb");
            }
        });

        btnNutritionalTip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startTipActivity("Tip Nutricional",receta.getTip_nutricional(),"light_bulb");

            }
        });

        btnWatch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(), VideoActivity.class);
                intent.putExtra("URL",receta.getVideo());
                startActivity(intent);
            }
        });

        Picasso.with(getApplicationContext()).load(receta.getThumbnail())
                .resize(imgBackground.getWidth(),imgBackground.getHeight())
                .into(imgBackground);

        txtVariants.setText(receta.getVariante());

        //Set ing
        ArrayList<RecipeStepElement> stepsList = new ArrayList<>();
        for (ListIterator<String> iter = receta.getPasos().listIterator(); iter.hasNext(); ) {
            String element = iter.next();
            stepsList.add(new RecipeStepElement(element));
        }
        rvSteps.setLayoutManager(new LinearLayoutManager(this));
        rvSteps.setAdapter(new RecipeRecyclerViewAdapter(stepsList,true));
    }
}
