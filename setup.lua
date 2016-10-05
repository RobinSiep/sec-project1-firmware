local setup = {}

setup.wifi = function()
    print("setup")
    enduser_setup.start(
        function()
            print("Connected")
        end
    )
end

enduser_setup.start(
        function()
            print("Connected")
        end,
        function(err, str)
            print(err, str)
        end
)
    
return setup
