import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type ExpenseId = Nat;
  
  type Expense = {
    id : ExpenseId;
    description : Text;
    amount : Nat;
    participants : [Text];
    date : Time.Time;
  };

  var expenses = Buffer.Buffer<Expense>(0);

  public func addExpense(description : Text, amount : Nat, participants : [Text]) : async ExpenseId {
    let expenseId = expenses.size();
    let newExpense : Expense = {
      id = expenseId;
      description = description;
      amount = amount;
      participants = participants;
      date = Time.now();
    };
    expenses.add(newExpense);
    expenseId;
  };

  public query func getExpense(expenseId : ExpenseId) : async ?Expense {
    if (expenseId < expenses.size()) {
      ?expenses.get(expenseId);
    } else {
      null;
    };
  };

  public query func getAllExpenses() : async [Expense] {
    Buffer.toArray(expenses);
  };

  public query func getExpensesByParticipant(participant : Text) : async [Expense] {
    let results = Buffer.Buffer<Expense>(0);
    for (expense in expenses.vals()) {
      for (p in expense.participants.vals()) {
        if (Text.equal(p, participant)) {
          results.add(expense);
        };
      };
    };
    Buffer.toArray(results);
  };
};