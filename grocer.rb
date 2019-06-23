 def consolidate_cart(cart)
  consolidated_hash = {}
  cart.each do |item|
    item.each do |item_name, item_info_hash|
      if consolidated_hash[item_name]
        consolidated_hash[item_name][:count] += 1 
      else
        consolidated_hash[item_name] = item_info_hash
        consolidated_hash[item_name][:count] = 1 
      end
    end
  end 
  consolidated_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    if cart.keys.include?(coupon_hash[:item])
      if cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
        new_item_name = "#{coupon_hash[:item]} W/COUPON"
        if cart[new_item_name]
          cart[new_item_name][:count] += coupon_hash[:num]
        else
          cart[new_item_name] = {
          :price => (coupon_hash[:cost] / coupon_hash[:num]).round(2),
          :clearance => cart[coupon_hash[:item]][:clearance],
          :count => coupon_hash[:num]
        }
        end
        cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
      end
    end #end of if
  end #end of coupons.each do
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)
  
  total = 0 
  consolidated_cart.each do |item, item_hash|
    total += item[item_hash[:price]] * item[item_hash[:count]]
  end
end
