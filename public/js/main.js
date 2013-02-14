var mm = angular.module('mm', []);

mm.directive('rightClick', function () {
  return function (scope, element, attr) {
    element.bind('contextmenu', function (event) {
      event.preventDefault();
      scope.$eval(attr['rightClick']);
      scope.$apply();
      return false;
    });
  }
});

mm.controller('GameCtrl', ['$scope', '$http', function ($scope, $http) {

  function Cell(val, x, y) {
    return {
      val: val,
      cleared: false,
      flagged: false,
      x: x,
      y: y,
      clear: function () {
        this.cleared = true;
      },
      flag: function () {
        this.flagged = true;
      },
      isFlagged: function () {
        return this.flagged;
      },
      isBomb: function () {
        return val == "B";
      },
      isCleared: function () {
        return this.cleared;
      },
      isBlank: function () {
        return val == 0;
      },
      isNum: function () {
        return val > 0;
      }
    }
  }

  function Game() {
    return {
      board: null,
      gameOver: false,
      gameWin: false,
      calcIsGameWin: function () {
        var gameWin = true;
        _(this.board.cells).each(function (row) {
          _(row).each(function (cell) {
            if (cell.isBomb() && !cell.isFlagged()) {
              gameWin = false;
            }
          });
        });
        this.gameWin = gameWin;
      },
      flagCell: function (cell) {
        cell.flag();
        this.calcIsGameWin();
      },
      clearCell: function (cell) {
        cell.clear();
        if (cell.isBomb()) {
          this.clearAllBombs()
        } else if (cell.isBlank()) {
          this.clearSurroundingCells(cell);
        }
        this.calcIsGameWin();
      },
      cellAt: function (x, y) {
        return (x == -1 || y == -1) ? null : this.board.cells[y][x];
      },
      clearSurroundingCells: function (cell) {
        function clearIfValid(cell) {
          if (cell && !cell.isCleared()) { 
            this.clearCell(cell) 
          }
        }
        // W
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), cell.y));
        // E
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), cell.y));
        // N
        clearIfValid.call(this, this.cellAt(cell.x, this.upRow(cell.y)));
        // S
        clearIfValid.call(this, this.cellAt(cell.x, this.downRow(cell.y)));
        // NW
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), this.upRow(cell.y)));
        // NE
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), this.upRow(cell.y)));
        // SW
        clearIfValid.call(this, this.cellAt(this.prevCol(cell.x), this.downRow(cell.y)));
        // SE
        clearIfValid.call(this, this.cellAt(this.nextCol(cell.x), this.downRow(cell.y)));
      },
      prevCol: function (x) {
        return x > 0 ? x - 1 : -1;
      },
      nextCol: function (x) {
        return x < this.board.cells[0].length - 1 ? x + 1 : -1;
      },
      upRow: function (y) {
        return y > 0 ? y - 1 : -1;
      },
      downRow: function (y) {
        return y < this.board.cells.length - 1 ? y + 1 : -1;
      },
      clearAllBombs: function () {
        _(this.board.cells).each(function (row) {
          _(row).each(function (cell) {
            if (cell.isBomb()) {
              cell.clear();
            }
          });
        });
        this.gameOver = true;
      },
      start: function () {

        function convertBoard(board) {
          var convertedBoard = {
            cells: []
          };
          _(board).each(function (row, y) {
            convertedBoard.cells.push([]); // new row
            _(row).each(function (col, x) {
              convertedBoard.cells[y].push(new Cell(col == "*" ? "B" : col, x, y));
            });
          });
          return convertedBoard;
        }

        var self = this;
        this.board = {};
        
        $http.get('/ws/board/5/5/easy')
          .success(function (data) {
            self.board = convertBoard(data);
          })
          .error(function (data) {
            alert('Error!');
          });
      }
    }    
  }

  $scope.game = new Game()
  $scope.game.start();

}]);

