class List
  attr_reader(:name, :id, :due_date)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @due_date = attributes.fetch(:due_date)
  end

  define_singleton_method(:all) do
    returned_lists = DB.exec("SELECT * FROM lists;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      due_date = list.fetch("due_date")
      lists.push(List.new({:name => name, :id => id, :due_date => due_date}))
    end
    lists
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO lists (name, due_date) VALUES ('#{@name}', '#{@due_date}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_singleton_method(:sort) do
    returned_lists = DB.exec("SELECT * FROM lists ORDER BY due_date;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      due_date = list.fetch("due_date")
      lists.push(List.new({:name => name, :id => id, :due_date => due_date}))
    end
    lists
  end

  define_method(:==) do |another_list|
    self.name().==(another_list.name()).&(self.id().==(another_list.id())).&self.due_date().==(another_list.due_date())
  end
end
