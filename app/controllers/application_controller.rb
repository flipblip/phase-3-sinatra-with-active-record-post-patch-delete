class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end


  # ---------------------- HANDLING DELETE REQUESTS -------------------

  # Our users may need a way to delete their reviews.
  # To accomplish this, the server will handle a few things
  # - Handle requests witht he DELETE HTTP verb to /reviews/:id
  # - Find the review to delete using its ID
  # - Delete the review from the db
  # - Send a response with the deleted review as JSON to confirm that it was deleted successfully


  # ----------------- OUR REACT COMPONENT TO HANDLE THE REQUESTS MAY LOOK LIKE ---

  # function ReviewItem({ review, onDeleteReview }) {
  #   function handleDeleteClick() {
  #     fetch(`http://localhost:9292/reviews/${review.id}`, {
  #       method: "DELETE",
  #     })
  #       .then((r) => r.json())
  #       .then((deletedReview) => onDeleteReview(deletedReview));
  #   }
  
  #   return (
  #     <div>
  #       <p>Score: {review.score}</p>
  #       <p>{review.comment}</p>
  #       <button onClick={handleDeleteClick}>Delete Review</button>
  #     </div>
  #   );
  # }

  delete '/reviews/:id' do
    # find the review using the ID
    review = Review.find(params[:id])
    # delte the review
    review.destroy
    #  send a response witht the deleted review as JSON
    review.to_json
    
  end

  # ------------------------------------------------- HANDLING POST REQUESTS -------------

  # function ReviewForm({ userId, gameId, onAddReview }) {
  #   const [comment, setComment] = useState("");
  #   const [score, setScore] = useState("0");
  
  #   function handleSubmit(e) {
  #     e.preventDefault();
  #     fetch("http://localhost:9292/reviews", {
  #       method: "POST",
  #       headers: {
  #         "Content-Type": "application/json",
  #       },
  #       body: JSON.stringify({
  #         comment: comment,
  #         score: score,
  #         user_id: userId,
  #         game_id: gameId,
  #       }),
  #     })
  #       .then((r) => r.json())
  #       .then((newReview) => onAddReview(newReview));
  #   }
  
  #   return <form onSubmit={handleSubmit}>{/* controlled form code here*/}</form>;
  # }

  post '/reviews' do

    # We're leveraging the rack middleware use Rack::JSONBodyParser in the config.ru file
    # The mdidleware reads the body of the request, parses it from a JSON strign into a ruby hash,
    # It then adds it to the params hash

    # binding.pry

    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )


    review.to_json

  end


   # ------------------------------------------------- HANDLING PATCH REQUESTS -------------

  #  OUr react component may look like this

  #  function EditReviewForm({ review, onUpdateReview }) {
  #   const [comment, setComment] = useState("");
  #   const [score, setScore] = useState("0");
  
  #   function handleSubmit(e) {
  #     e.preventDefault();
  #     fetch(`http://localhost:9292/reviews/${review.id}`, {
  #       method: "PATCH",
  #       headers: {
  #         "Content-Type": "application/json",
  #       },
  #       body: JSON.stringify({
  #         comment: comment,
  #         score: score,
  #       }),
  #     })
  #       .then((r) => r.json())
  #       .then((updatedReview) => onUpdateReview(updatedReview));
  #   }
  
  #   return <form onSubmit={handleSubmit}>{/* controlled form code here*/}</form>;
  # }

  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    review.to_json
  end
  
  

  


end
