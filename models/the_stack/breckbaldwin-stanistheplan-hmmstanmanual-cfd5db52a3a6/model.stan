data {
  int cat_count;  // num categories
  int word_count;  // num words
  int data_count;  // num instances
  array[data_count] int words; // words
  array[data_count] int categories; // categories
  vector[cat_count] alpha;  // transit prior
  vector[word_count] beta;   // emit prior
}

parameters {
  array[cat_count] simplex[cat_count] transition_p;  //
  array[cat_count] simplex[word_count] emit_p;    //
}

model {
  for (k in 1:cat_count) 
    transition_p[k] ~ dirichlet(alpha);
  for (k in 1:cat_count)
    emit_p[k] ~ dirichlet(beta);

  for (t in 1:data_count) {
    words[t] ~ categorical(emit_p[categories[t]]);
    print("words=",words[t],",  categorical over emit probs: ",emit_p[categories[t]]);
  }

  for (t in 2:data_count) {
    categories[t] ~ categorical(transition_p[categories[t - 1]]);
    print("category=",categories[t],",  categorical over tranisiton probs: ",transition_p[categories[t-1]]);
  }
}


