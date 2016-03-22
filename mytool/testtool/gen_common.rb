module GenCommon
  class Incrementer
    def initialize(init_val=0)
      @init_val = init_val
    end

    def next(step=1)
      @init_val += step
    end
  end

  class ItemDataGenerator
    def initialize(csv_headers=[])
      @csv_headers = csv_headers
      @hash_gens = {}      
    end
    def set_item_gen(item, &block)
      @hash_gens[item] = block
    end
    def get_next_data(hash_data={})
      result = []
      @csv_headers.each_with_index { |value, index|
        hash_data[value] = @hash_gens[value].call if hash_data[value].nil?
        result[index] = hash_data[value]
      }
      result
    end
  end

  def self.comment_extract(target_pattern, result_path, comment_sign="#")
    Dir.glob(target_pattern).sort.each do |f|
      result_file = File.join(result_path, File.basename(f))
      File.open(result_file, "wb") do |result|
        File.open(f, "r").each do |line|
           result.write(line) if !line.start_with?(comment_sign)
        end
      end
    end
  end
end
