import React from 'react'
import { Link } from 'react-router-dom'
import { Pagination } from 'react-bootstrap'

class Fridge extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      recipes: [],
      ingredients: [{ name: '' }],
      strictIngredients: false,
      sortMethod: 'match_sort',
      pagination: { currentPage: 1, pages: 1 },
    }

    this.addIngredient = this.addIngredient.bind(this)
    this.handleInputChange = this.handleInputChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.changePage = this.changePage.bind(this)
    this.getData = this.getData.bind(this)
    this.handleStrictIngredients = this.handleStrictIngredients.bind(this)
    this.changeSort = this.changeSort.bind(this)
  }

  addIngredient (e) {
    const { ingredients } = this.state
    console.log(ingredients)
    if (ingredients[ingredients.length - 1].name === '') {
      return
    }
    this.setState((prevState) => ({
      ingredients: [...prevState.ingredients, { name: '' }],
    }))
  }

  handleSubmit (e) {
    e.preventDefault()
    this.getData(1)
  }

  getData (pageNum) {
    const { ingredients, strictIngredients, sortMethod } = this.state

    let ingredientParams = ingredients.map(
      (ing) => {return `ingredients[]=${ing.name}`}).join('&')
    console.log(ingredientParams)
    let requestUrl = `/api/v1/recipes?page=${pageNum}&strict_ingredients=${strictIngredients}&sort_method=${sortMethod}&${ingredientParams}`
    fetch(requestUrl).
      then(response => response.json()).
      then(data => this.setState({
        recipes: data['recipes'],
        pagination: {
          currentPage: data['meta']['current_page'],
          pages: data['meta']['pages'],
        },
      }))
  }

  changePage (pageNum) {
    this.setState((prevState) => ({
      pagination: { currentPage: pageNum, pages: prevState.pagination.pages },
    }))
    this.getData(pageNum)
  }

  handleInputChange (index, event) {
    const { ingredients } = this.state
    console.log(index)
    ingredients[index].name = event.target.value

    this.setState(ingredients)
  };

  handleStrictIngredients (e) {
    this.setState({ strictIngredients: e.target.checked })
  }

  changeSort (e) {
    console.log(e.target.value)
    this.setState({ sortMethod: e.target.value })
  }

  render () {
    let { ingredients, strictIngredients } = this.state
    const { recipes } = this.state
    const { currentPage, pages } = this.state.pagination
    const allRecipes = recipes.map((recipe, index) => (
      <div key={index} className="col-md-6 col-lg-4">
        <div className="card mb-4">
          <img
            src={recipe.image}
            className="card-img-top"
            alt={`${recipe.name} image`}
          />
          <div className="card-body">
            <h5 className="card-title">{recipe.name}</h5>
            <Link to={`/recipe/${recipe.id}`} className="btn custom-button">
              View Recipe
            </Link>
          </div>
        </div>
      </div>
    ))
    const noRecipe = (
      <div
        className="vw-100 vh-50 d-flex align-items-center justify-content-center">
        <h4>
          No recipes found
        </h4>
      </div>
    )
    let items = []
    for (let number = 1; number <= pages; number++) {
      items.push(
        <Pagination.Item key={number} active={number === currentPage}
                         onClick={() => {this.changePage(number)}}>
          {number}
        </Pagination.Item>,
      )
    }

    const paginationBasic = (
      <div>
        <Pagination size="sm">{items}</Pagination>
      </div>
    )

    return (
      <div className="mb-lg-3">
        <div className="mb-3">
          <h1>Search recipes based on what you have in your fridge</h1>

          <form onSubmit={this.handleSubmit}>
            <div className="mb-3">
              <label className="form-label">Fridge Content</label>
              {
                ingredients.map((val, idx) => {
                  let ingredientId = `ingredient-${idx}`
                  return (
                    <div className="input-group mb-3" key={idx}>
                      <input type="text" name={ingredientId} data-id={idx}
                             className="form-control"
                             id={ingredientId} onChange={event => {
                        this.handleInputChange(idx, event)
                      }}/>
                    </div>
                  )
                })
              }
              <button type="button" className="btn btn-info"
                      onClick={this.addIngredient}>
                Add new ingredient
              </button>
              <div>
                <div className="mb-3 form-check">
                  <input type="checkbox" className="form-check-input"
                         id="strict_ingredients" value={strictIngredients}
                         onChange={this.handleStrictIngredients}/>
                  <label className="form-check-label">Use
                    only what I have in fridge</label>
                </div>
                <select className="form-select"
                        aria-label="Default select example"
                        onChange={this.changeSort}>
                  <option defaultValue value="match_sort">Sort by match rate
                  </option>
                  <option value="count_sort">Sort by number of ingredients
                  </option>
                </select>
              </div>


              <input type="submit" className="btn btn-primary" value="Search"/>
            </div>
          </form>
        </div>

        <div className="py-5">
          <main className="container">
            <div className="row">
              {recipes.length > 0 ? allRecipes : noRecipe}
            </div>
          </main>
          {recipes.length > 0 ? paginationBasic : ''}
        </div>
      </div>
    )
  }

}

export default Fridge
