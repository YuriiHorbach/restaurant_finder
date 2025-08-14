class String
  def titelize
    self.split(' ').map{ |word| word.capitalize}.join(' ')
  end
end
