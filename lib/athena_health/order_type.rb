module AthenaHealth
  class OrderType < BaseModel
    attribute :ordertypeid,         Integer
    attribute :ordertypename,       String
    attribute :ordergenusname,      String
    attribute :ordertypegroupname,  String
    attribute :ordertypegroupid,    Integer
  end
end
