class Report < Prawn::Document
   def customer
      headers = %w[Name Email Desc Staff]
      headers2 = %w[Name Age Adress ]
      data = []
      data2 = []
      count = 0
      Customer.all(:order => "name").each do |a|
      count += 1
      data << [a.name, a.email, a.desc, a.satff.name]
      data2 <<[a.satff.name, a.satff.age, a.satff.address]
      end

      text "Total Contact : #{count.to_s}"
      table([headers] + data, :header => true, :row_colors => %w[cccccc ffffff]) do |t|
               t.row(0).style :background_color => '000000', :text_color => 'ffffff'
               t.cells.style :borders => []
      end
       table([headers2] + data2, :header => true, :row_colors => %w[cccccc ffffff]) do |t|
               t.row(0).style :background_color => '000000', :text_color => 'ffffff'
               t.cells.style :borders => []
      end

        string = "page <page> of <total>"
        options = { :at => [bounds.right - 150, 0],
        :width => 150,
        :align => :right,
        :start_count_at => 1,
        :page_filter => (1..page_count),

        :color => "007700" }
       move_down 10
       text "End Of Report"
       number_pages string, options
      render
    end

    def customer_credit_note
      # Assign the path to your file name first to a local variable.
      logopath = "#{RAILS_ROOT}/public/images/rfc.png.jpg"

      # Displays the image in your PDF. Dimensions are optional.
      pdf.image logopath, :width => 197, :height => 91
    end
end
