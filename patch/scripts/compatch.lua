CP_VERSION = "1.12"

-- Отображение первого текста рассказчика
-- вынесено сюда, так как текст имеет разную скорость в патче и ремастере
function ShowFirstNarratorText()
    AddCinematicMessage( 77771, 0.1)
end