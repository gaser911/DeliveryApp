# food_app

Food Delivery app 


# File Architecture

lib/ 


core/
+constants/ -- api_endpoints.dart  app.colors.dart  app_string.dart

+network/   -- api_service.dart  api_excepion.dart 

+utils/   ---helper.dart    validators.dart





features/  # each feature gonna have 3 main folders  -- 

/data --  feauture_model.dart  feature_repository.dart

/view --  would carry main pages 

/widgets --break down into small widgets 

+ adding cubit file for state managemant 


shared folder // widgets to be shared all over the App 