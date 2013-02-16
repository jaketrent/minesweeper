mm = angular.module("mm", [])

mm.directive "rightClick", ->
  (scope, element, attr) ->
    element.bind "contextmenu", (event) ->
      event.preventDefault()
      scope.$eval attr["rightClick"]
      scope.$apply()
      false

mm.controller "GameCtrl", ["$scope", "$http", ($scope, $http) ->
  Cell = (val, x, y) ->
    val: val
    cleared: false
    flagged: false
    hit: false
    x: x
    y: y
    clear: ->
      @cleared = true

    toggleFlag: ->
      @flagged = not @flagged

    hit: ->
      @hit = true

    isHit: ->
      @hit

    isFlagged: ->
      @flagged

    isBomb: ->
      val is "B"

    isCleared: ->
      @cleared

    isBlank: ->
      val is 0

    isNum: ->
      val > 0
  Game = ->
    modes = [
      { name: "easy" },
      { name: "normal" },
      { name: "hard" },
      { name: "insane" }
    ]
    board: null
    gameOver: false
    gameWon: false
    gameError: false
    modes: modes
    mode: modes[1]
    newGameMode: modes[1]
    isStopGame: ->
      @gameOver or @gameWon

    calcIsGameWon: ->
      gameWon = true
      _(@board.cells).each (row) ->
        _(row).each (cell) ->
          if cell.isBomb() and not cell.isFlagged()
            gameWon = false
          else gameWon = false  if not cell.isBomb() and not cell.isCleared()
      if gameWon
        analytics.track "Game end"
          result: "Win"
          mode: @mode.name
      @gameWon = gameWon

    flagCell: (cell) ->
      return if @isStopGame()
      cell.toggleFlag()
      @calcIsGameWon()

    clearCell: (cell) ->
      return if @isStopGame()
      cell.clear()
      if cell.isBomb()
        cell.hit()
        @clearAllBombs()
      else @clearSurroundingCells cell  if cell.isBlank()
      @calcIsGameWon()

    cellAt: (x, y) ->
      if (x is -1 or y is -1) then null else @board.cells[y][x]

    clearSurroundingCells: (cell) ->
      clearIfValid = (cell) =>
        @clearCell cell  if cell and not cell.isCleared()
      # W
      clearIfValid @cellAt(@prevCol(cell.x), cell.y)
      # E
      clearIfValid @cellAt(@nextCol(cell.x), cell.y)
      # N
      clearIfValid @cellAt(cell.x, @upRow(cell.y))
      # S
      clearIfValid @cellAt(cell.x, @downRow(cell.y))
      # NW
      clearIfValid @cellAt(@prevCol(cell.x), @upRow(cell.y))
      # NE
      clearIfValid @cellAt(@nextCol(cell.x), @upRow(cell.y))
      # SW
      clearIfValid @cellAt(@prevCol(cell.x), @downRow(cell.y))
      # SE
      clearIfValid @cellAt(@nextCol(cell.x), @downRow(cell.y))

    prevCol: (x) ->
      (if x > 0 then x - 1 else -1)

    nextCol: (x) ->
      (if x < @board.cells[0].length - 1 then x + 1 else -1)

    upRow: (y) ->
      (if y > 0 then y - 1 else -1)

    downRow: (y) ->
      (if y < @board.cells.length - 1 then y + 1 else -1)

    clearAllBombs: ->
      _(@board.cells).each (row) ->
        _(row).each (cell) ->
          cell.clear()  if cell.isBomb()
      @gameOver = true
      analytics.track "Game end",
        result: "Loss"
        mode: @mode.name

    mode: ($event) ->
      console.log $event.target

    resetState: ->
      @board = {}
      @gameWon = false
      @gameOver = false
      @mode = @newGameMode

    start: ->
      convertBoard = (board) ->
        convertedBoard = cells: []
        _(board).each (row, y) ->
          convertedBoard.cells.push [] # new row
          _(row).each (col, x) ->
            convertedBoard.cells[y].push new Cell((if col is "*" then "B" else col), x, y)
        convertedBoard

      @resetState()
      $http.get("/ws/board/" + @mode.name).success((data) =>
        @board = convertBoard(data)

        analytics.track "New game", { mode: @mode.name }
      ).error (data) =>
        @gameError = true

  $scope.game = new Game()
  $scope.game.start()
]