Sequel.seed do
  def run
    [
      ['автобус', 'bus'],
      ['чашка', 'cup'],
      ['стіл', 'table']
    ].each do |desc, tag|
      Word.create description: desc, tag: tag
    end
  end
end
