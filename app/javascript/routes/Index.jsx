import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Recipes from "../components/Recipes";
import Recipe from '../components/Recipe'
import Fridge from '../components/Fridge'

export default (
  <Router>
    <Switch>
      <Route path="/" exact component={Fridge} />
      <Route path="/recipes" exact component={Recipes} />
      <Route path="/recipe/:id" exact component={Recipe} />
      <Route path="/fridge" exact component={Fridge} />
    </Switch>
  </Router>
);
