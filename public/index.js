var gameTimer = null;

$(function() {
  // updatePageLoadCounter();
  $('input#start-game').on('click', startGame);
  $('input#end-game').on('click', endGame);
  $('input#make-guess').on('click', makeGuess);
  $('input#word-input').keyup(function(event){
    if(event.keyCode == 13) {
      makeGuess();
    }
  });
})

function startGame() {
  $('input#start-game').prop('disabled', true);
  $('input#word-input').prop('disabled', false);
  $('input#make-guess').prop('disabled', false);
  $('input#end-game').prop('disabled', false);
  $('div#guess-result').html('<br>');
  [$('table#correct-guesses'), $('table#incorrect-guesses'), $('table#all-synonyms')].forEach(function(table) {
    table.html('<tbody><tr></tr></tbody>');
  })
  
  $.ajax({
    type: 'post',
    url: '/startGame.json',
    dataType: 'json',
    success: setSelectedWord
  })
}

function endGame() {
  $('input#start-game').prop('disabled', false);
  $('input#word-input').prop('disabled', true);
  $('input#make-guess').prop('disabled', true);
  $('input#end-game').prop('disabled', true);
  window.clearInterval(gameTimer);
  $('span#timer').html(0);
  $.ajax({
    type: 'post',
    url: '/endGame.json',
    dataType: 'json',
    success: showHitsAndMisses
  })
  $('span#current-score').html("0");
}

function makeGuess() {
  let guessedWord = $('input#word-input').val().trim();
  $.ajax({
    type: 'post',
    url: '/makeGuess.json',
    dataType: 'json',
    data: {"guess": guessedWord},
    success: parseGuessReturn
  })
  $('input#word-input').val('');
}

function setSelectedWord(response) {
  $('div#selected-word').html(response.current_word);
  startGameTimer();
}

function parseGuessReturn(response) {
  switch(response.returned_value) {
    case "Already guessed":
    $('div#guess-result').html("Already guessed that one, can't fool me!");
    break;
    case "Original word":
    $('div#guess-result').html("Well, I mean, yeah...");
    break;
    case false:
    updateGuessTable('incorrect-guesses', response.guess)
    $('div#guess-result').html("Incorrect! Try again.");
    break;
    default:
    let totalScore = updateScores(response.returned_value);
    updateGuessTable('correct-guesses', response.guess)
    $('div#guess-result').html(`Correct! That word was worth ${response.returned_value} points. Your score is ${totalScore}.`);
    break;
  }
}

function updateScores(value) {
  let currentScore = $('span#current-score').html();
  currentScore = parseInt(currentScore) + value;
  let totalScore = $('span#total-score').html();
  totalScore = parseInt(totalScore) + value;
  $('span#current-score').html(currentScore);
  $('span#total-score').html(totalScore);
  return totalScore;
}

function showHitsAndMisses(response) {
  // $('div#correct-guesses').html(response.hits_and_misses.guesses_correct);
  // $('div#incorrect-guesses').html(response.hits_and_misses.guesses_incorrect);
  // $('div#synonym-list').html(response.hits_and_misses.all_words + response.hits_and_misses.all_words_guessed);
  response.hits_and_misses.all_words.forEach(function(item) {
    updateGuessTable('all-synonyms', item)
  });
  $('table#all-synonyms').children('tbody').append('<tr></tr>')
  response.hits_and_misses.all_words_guessed.forEach(function(item) {
    updateGuessTable('all-synonyms', item)
  });
}

function startGameTimer() {
  let timeInGame = 60;
  $('span#timer').html(timeInGame);
  gameTimer = setInterval(myTimer, 1000);

  function myTimer() {
    console.log("current time left: " + timeInGame)
    timeInGame--
    $('span#timer').html(timeInGame);
    if (timeInGame === 0) {
      endGame();
      window.clearInterval(gameTimer);
    }
  };
}

function updateGuessTable(tableName, word) {
  var table = $('table#' + tableName);
  var lastRow = table.children('tbody').children('tr:last');
  if (lastRow.children('td').length <= 5) {
    lastRow.append(`<td class="col-md-2 td-left">${word}</td>`);
  } else {
    table.append(`<tr><td class="col-md-2 td-left">${word}</td></tr>`)
  }
}

function updatePageLoadCounter() {
  $.ajax({
    type: 'post',
    url: '/newView.json',
    dataType: 'json'
    // data: {"guess": guessedWord},
    // success: parseGuessReturn
  })
}