let
    Source = Table.FromList(
        {1..89},   // Gera a lista de números de 1 a 1000
        Splitter.SplitByNothing(),
        {"Id_Time"}, // Nome da coluna
        type table [Id_Time = number] // Tipo da coluna
    ),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Id_Time", Int64.Type}}),
    Custom1 = Table.AddColumn(#"Changed Type", "Times", each fxGetTime([Id_Time])),
    #"Expanded Times" = Table.ExpandTableColumn(Custom1, "Times", {"nome_popular", "sigla", "escudo"}, {"nome_popular", "sigla", "escudo"})
in
    #"Expanded Times"
