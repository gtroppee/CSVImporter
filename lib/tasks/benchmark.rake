task :benchmark, [:rows_count] do |t, args|
  Benchmark.bm do |x|
    file = Tempfile.new('csv_data')

    x.report("CSV file generation") do
      CSV.open(file, 'w', headers: true) do |csv|
        csv << %w(reference address zip_code city country manager_name)
        args[:rows_count].to_i.times do |i|
          csv << [i.to_s, '10 Rue La bruyère', '75009', 'Paris', 'France', 'Martin Faure']
        end
      end
    end

    x.report("CSV processing [CREATE]") do |times|
      Import.new({ file: file, type: 'Building' }).save
    end

    x.report("CSV processing [UPDATE]") do |times|
      Import.new({ file: file, type: 'Building' }).save
    end
  end

  puts "Total Buildings : #{Building.count}"

  Building.delete_all
end