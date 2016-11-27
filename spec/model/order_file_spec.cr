require "../spec_helper"
require "../../src/edi/model/order_file.cr"

describe Edi::Model::OrderFile do
  describe "#initialize" do
    it "correctly initialize all properties" do
      model = Edi::Model::OrderFile.new "files/"
      list = [] of Edi::Model::OrderItem

      model.itens.should eq list
    end
  end

  describe "#add_item" do
    it "adds an OrderItem to #itens" do
      item = Edi::Model::OrderItem.new(
        "7894900700046",
        5.to_i64,
        false,
        10.0.to_f64,
        3.99.to_f64
      )
      model = Edi::Model::OrderFile.new "files/"
      model.add_item item

      model.itens.size.should eq 1
      model.itens[0].should eq item
    end
  end

  describe "#save" do
    it "writes to file" do
      model = Edi::Model::OrderFile.new "/tmp/"
      file_path = model.file_path
      File.exists?(file_path).should be_false
      model.save.should be_true
      File.exists?(file_path).should be_true
    end
  end

  describe "#file_path" do
    it "returns coorect file path" do
      model = Edi::Model::OrderFile.new "files/"
      model.id = 123.to_i64
      model.wholesaler_code = "SANTACRUZ"
      model.project_code = "GSK"

      # Remove Random uuid from the end
      actual = model.file_path[0..-38]
      expected = "files/PEDIDO_0000000123_00000SANTACRUZ_GSK.PED"
      actual.should eq expected
    end
  end
end
