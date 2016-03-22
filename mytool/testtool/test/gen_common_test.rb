require "test/unit"
require "csv"
require File.join(File.dirname(__FILE__), '..', 'gen_common')

class TestGenCommon < Test::Unit::TestCase
  def setup
    @inc = GenCommon::Incrementer.new
  end

  def test_next
    assert_equal(1, @inc.next)
    assert_equal(2, @inc.next)
    assert_equal(4, @inc.next(2))
  end
  def test_comment_extract
    CSV.open(File.join(File.dirname(__FILE__), "temp.csv"), "wb") do |csv|
      ["first","second", "third"].each do |item|
        csv << ["##{item} line comment"]
        csv << ["#{item} line data"]
      end
    end 
    GenCommon.comment_extract(File.join(File.dirname(__FILE__), "*.csv"), "/tmp/")
    CSV.open("/tmp/temp.csv", "r") do |csv|
      ["first", "second", "third"].each do |item|
        assert_equal( ["#{item} line data"], csv.readline )
      end
    end
    File.delete("/tmp/temp.csv")
    File.delete("temp.csv")
  end
  def test_next_data
    dg = GenCommon::ItemDataGenerator.new([:first,:second,:third])
    r1 = 0
    dg.set_item_gen(:first) { r1 += 1 }
    r2 = ""
    dg.set_item_gen(:second) { r2 << "a" }
    r3 = ""
    dg.set_item_gen(:third) { r3 << "c"}
    assert_equal [100, "a" , "c"], dg.get_next_data(:first => 100)
    assert_equal [1, "aa", 300], dg.get_next_data(:third => 300)
    assert_equal r1, 1
    assert_equal r2, "aa"
    assert_equal r3, "c"
  end
end


