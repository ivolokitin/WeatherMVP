Исправить:

- (CRITICAL) выгрузить массив UIImage заранее, чтобы при прокрутке tableView не нужно было каждый раз проходить по массиву и получать изображение на базе URL

- оптимизируй constraints / stackView DetailedWeatherView

+ разный цвет у элементов HourlyView - UICollectionView и у Daily-, Detailed - проверь alpha и прочее

- добавить showMessage() / showError() на всех этапах guard { return }

- tableView - Daily: убрать lines, selection

- iPhone 8: в HourlyView отображается только иконка - исправить contstaints / stackview

- финальный экран должен быть в форме stackView - а не leading=0 --> arrangedSubviews: [current, H-, D-, detailed]

- столбики collectionView - Hourly: коэффициент 2 или 3? (если погода не меняется, то что?)


Опционально:

- (iPad) для iPad collectionView занимает только половину экрана

- (iPad) larger font sizes for ipad (как оформляются отдельные куски кода для отдельных устройств?)

- (iPad) larger background image



Уже не в MVP (на будущее):

- смена картинок в соответствии с погодой

- зарефакторить все эти constraints в нормальные методы (anchor(), setDimensions())

- в Daily в случае дождя показывать статус "дождь" или зонтик

- (massive) add side menu -> change location -> Controller, Search, Delegates (как выгрузить список городов из базы OpenWeatherMap?)
