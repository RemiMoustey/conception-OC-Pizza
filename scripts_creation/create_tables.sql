
CREATE SEQUENCE public.point_of_sale_id_seq;

CREATE TABLE public.point_of_sale (
                id INTEGER NOT NULL DEFAULT nextval('public.point_of_sale_id_seq'),
                name VARCHAR(255) NOT NULL,
                address TEXT NOT NULL,
                CONSTRAINT point_of_sale_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.point_of_sale_id_seq OWNED BY public.point_of_sale.id;

CREATE SEQUENCE public.ingredient_id_seq;

CREATE TABLE public.ingredient (
                id INTEGER NOT NULL DEFAULT nextval('public.ingredient_id_seq'),
                name VARCHAR(255) NOT NULL,
                stock INTEGER NOT NULL,
                point_of_sale_id INTEGER NOT NULL,
                CONSTRAINT ingredient_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.ingredient_id_seq OWNED BY public.ingredient.id;

CREATE SEQUENCE public.employee_id_seq;

CREATE TABLE public.employee (
                id INTEGER NOT NULL DEFAULT nextval('public.employee_id_seq'),
                name VARCHAR(255) NOT NULL,
                numero VARCHAR(255) NOT NULL,
                login VARCHAR(255) NOT NULL,
                password VARCHAR(255) NOT NULL,
                is_connected BOOLEAN NOT NULL,
                role VARCHAR(100) NOT NULL,
                point_of_sale_id INTEGER NOT NULL,
                CONSTRAINT employee_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;

CREATE SEQUENCE public.category_id_seq;

CREATE TABLE public.category (
                id INTEGER NOT NULL DEFAULT nextval('public.category_id_seq'),
                name VARCHAR(255) NOT NULL,
                parent_category VARCHAR(255),
                parent_category_id INTEGER,
                CONSTRAINT category_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;

CREATE SEQUENCE public.pizza_menu_id_seq;

CREATE TABLE public.pizza_menu (
                id INTEGER NOT NULL DEFAULT nextval('public.pizza_menu_id_seq'),
                name VARCHAR(255) NOT NULL,
                description TEXT NOT NULL,
                price DOUBLE PRECISION NOT NULL,
                category_id INTEGER NOT NULL,
                is_available BOOLEAN NOT NULL,
                CONSTRAINT pizza_menu_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.pizza_menu_id_seq OWNED BY public.pizza_menu.id;

CREATE TABLE public.quantity_for_preparation (
                pizza_menu_id INTEGER NOT NULL,
                ingredient_id INTEGER NOT NULL,
                necessary_quantity INTEGER NOT NULL
);


CREATE TABLE public.reminder (
                pizza_menu_id INTEGER NOT NULL,
                recipe TEXT NOT NULL,
                CONSTRAINT reminder_pk PRIMARY KEY (pizza_menu_id)
);


CREATE SEQUENCE public.customer_id_seq;

CREATE TABLE public.customer (
                id INTEGER NOT NULL DEFAULT nextval('public.customer_id_seq'),
                numero VARCHAR(255) NOT NULL,
                name VARCHAR(255) NOT NULL,
                way VARCHAR(255) NOT NULL,
                complement_address TEXT,
                postal_code INTEGER NOT NULL,
                locality VARCHAR(100) NOT NULL,
                login VARCHAR(255) NOT NULL,
                password VARCHAR(255) NOT NULL,
                is_connected BOOLEAN NOT NULL,
                CONSTRAINT customer_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;

CREATE SEQUENCE public.request_id_seq;

CREATE TABLE public.request (
                id INTEGER NOT NULL DEFAULT nextval('public.request_id_seq'),
                customer_id INTEGER NOT NULL,
                numero VARCHAR(255) NOT NULL,
                date DATE NOT NULL,
                price DOUBLE PRECISION NOT NULL,
                list_pizzas TEXT NOT NULL,
                payment_method VARCHAR(255) NOT NULL,
                point_of_sale_id INTEGER NOT NULL,
                CONSTRAINT request_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.request_id_seq OWNED BY public.request.id;

CREATE TABLE public.request_status (
                status VARCHAR(255) NOT NULL,
                employee_id INTEGER NOT NULL,
                request_id INTEGER NOT NULL
);


CREATE TABLE public.payment (
                request_id INTEGER NOT NULL,
                date DATE NOT NULL,
                numero_delivery TEXT NOT NULL
);


CREATE TABLE public.ordered_pizza (
                pizza_id INTEGER NOT NULL,
                request_id INTEGER NOT NULL,
                price DOUBLE PRECISION NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT ordered_pizza_pk PRIMARY KEY (pizza_id)
);


ALTER TABLE public.request ADD CONSTRAINT pointofsale_request_fk
FOREIGN KEY (point_of_sale_id)
REFERENCES public.point_of_sale (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ingredient ADD CONSTRAINT point_of_sale_ingredient_fk
FOREIGN KEY (point_of_sale_id)
REFERENCES public.point_of_sale (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.employee ADD CONSTRAINT point_of_sale_employee_fk
FOREIGN KEY (point_of_sale_id)
REFERENCES public.point_of_sale (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.quantity_for_preparation ADD CONSTRAINT ingredient_composition_fk
FOREIGN KEY (ingredient_id)
REFERENCES public.ingredient (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.request_status ADD CONSTRAINT employee_status_fk
FOREIGN KEY (employee_id)
REFERENCES public.employee (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.category ADD CONSTRAINT category_category_fk
FOREIGN KEY (parent_category_id)
REFERENCES public.category (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pizza_menu ADD CONSTRAINT category_pizza_menu_fk
FOREIGN KEY (category_id)
REFERENCES public.category (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ordered_pizza ADD CONSTRAINT pizza_menu_ordered_pizza_fk
FOREIGN KEY (pizza_id)
REFERENCES public.pizza_menu (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.reminder ADD CONSTRAINT pizza_menu_reminder_fk
FOREIGN KEY (pizza_menu_id)
REFERENCES public.pizza_menu (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.quantity_for_preparation ADD CONSTRAINT pizza_menu_composition_fk
FOREIGN KEY (pizza_menu_id)
REFERENCES public.pizza_menu (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.request ADD CONSTRAINT customer_order_fk
FOREIGN KEY (customer_id)
REFERENCES public.customer (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.payment ADD CONSTRAINT order_payment_fk
FOREIGN KEY (request_id)
REFERENCES public.request (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ordered_pizza ADD CONSTRAINT order_ordered_pizza_fk
FOREIGN KEY (request_id)
REFERENCES public.request (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.request_status ADD CONSTRAINT request_status_fk
FOREIGN KEY (request_id)
REFERENCES public.request (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

INSERT INTO category
    (name)
VALUES
    ('Les suprêmes'),
    ('Les incontournables'),
    ('Les végétariennes')
;

INSERT INTO point_of_sale
    (name, address)
VALUES
    ('OC Pizza - Pizza Express', '4 rue des lilas, 54000 Nancy'),
    ('OC Pizza - La pizza prête', '56 route de la gloire, 63000 Clermont-Ferrand'),
    ('OC Pizza minute', '23 boulevard François Mitterrand, 75000 Paris'),
    (E'OC Pizza del\'arte', '5 rue des boules, 06000 Nice'),
    ('OC Pizza sur Garonne', '12 route de la Garonne, 33000 Bordeaux')
;

INSERT INTO customer
    (numero, name, way, complement_address, postal_code, locality, login, password, is_connected)
VALUES
    ('001', 'Jean Dupont', '3 rue des couloirs', '', 42000, 'Saint-Étienne', 'jdupont3', 'pizza', 'f'),
    ('002', 'Jérémy Gabory', '10 Impasse des roses', 'Appartement 3', 75000, 'Paris', 'gabory75', 'gaobrypizza','f'),
    ('008', 'James Craig', '18 rue des vignes', '', 63000, 'Clermont-Ferrand', 'craig63', 'foodpizza', 'f')
;

INSERT INTO employee
    (name, numero, login, password, is_connected, role, point_of_sale_id)
VALUES
    ('Jérôme Dury', '26612k', 'dury03', 'livrepizza', 'f', 'livreur', 1),
    ('François Buhr', '734', 'buhrfrancois', 'ocpizza', 'f', 'pizzaiolo', 1)
;

INSERT INTO pizza_menu
    (name, description, price, category_id, is_available)
VALUES
    ('Reine', 'Tomate, champignons, jambon, olives, fromage', 7.5, 2, 't'),
    ('4 fromages', E'Tomate, chèvre, mozzarella, roquefort, fourme d\'Ambert, olives, origan', 8, 2, 't'),
    ('Napolitaine', 'Tomate, anchois, olives, origan, fromage', 8.5, 1, 't'),
    ('Végétarienne', 'Tomate, pommes de terre, champignons, oignons, salade', 8, 3, 't'),
    ('Orientale', 'Mozzarella, merguez, poivrons, œuf', 7, 1, 't'),
    ('Pacifique', 'Mozzarella, thon, oignons, œuf', 7, 1, 't'),
    ('Margherita', 'Tomate, olives, origan, fromage', 7.5, 1, 't')
;

INSERT INTO reminder
    (pizza_menu_id, recipe)
VALUES
    (1, E'Etape 1\nPréchauffer le four à 220°C (thermostat 7/8).\nEtape 2\nFaire revenir les champignons à la poêle sur feu doux quelques minutes, sans les laisser griller.\nEtape 3\nÉtaler la pâte et la badigeonner de sauce tomate.\nEtape 4\nDisposer dessus le jambon et les champignons.\nEtape 5\nRecouvrir de gruyère râpé.\nEtape 6\nEnfourner pendant 30 ou 35 minutes à four chaud en surveillant de temps à autre.'),
    (2, E'Etape 1\nPréchauffer le four à 200°C (thermostat 6-7).\nEtape 2\nÉtaler la pâte à pizza et la recouvrir de crème fraiche.\nEtape 3\nMettre dessus les fromages en terminant par le gruyère râpé.\nEtape 4\nLaisser cuire 15 minutes.\nEtape 5\nOn peut ajouter le basilic juste avant de servir.'),
    (3, E'Etape 1\nPelez et hachez les oignons et l\'ail. Pelez et épépinez les tomates, découpez-les en dés.\nEtape 2\nFaites chauffer 2 cuillères à soupe d\'huile d\'olive. Mettez-les l\'ail et l\'oignon, laissez-les dorer. RAjoutez les tomates, salez, poivrez et ajoutez le thym.\nEtape 3\nLaissez cuire 20 minutes à feu moyen, jusqu\'à ce que le liquide soit évaporé.\nEtape 4\nLaissez refroidir.\nEtape 5\nPréchauffez le four à 240°C (thermostat 8).\nEtape 6\nEtalez la pâte sur une plaque huilée ou farinée. Etalez la sauce tomate dessus. Répartissez les anchois et les olives.\nEtape 7\nFaites cuire 15 minutes environ.'),
    (4, E'Etape 1\nDans un grand saladier, mettre environ 400 g de farine, le sel, l\'huile d\'olive et la levure (préalablement diluer dans un peu d\'eau tiède pour la levure sèche).\nEtape 2\nVerser progressivement l\'eau tiède tout en mélangeant à l\'aide d\'une spatule en bois.\nEtape 3\nTravailler la pâte en ajoutant de la farine si nécessaire jusqu\'à ce que la pâte n\'accroche plus au saladier.\nEtape 4\nCouvrir le saladier d\'un linge propre et laisser la pâte reposer 1h dans un endroit chaud.\nEtape 5\nPréchauffer le four à 200°C (thermostat 6-7).\nEtape 6\nEmincer les poivrons en lamelles puis couper la courgette et les oignons en rondelles avant de les faire revenir quelques minutes dans une poêle avec un peu d\'huile d\'olive.\nEtape 7\nMélanger la goustade d\'aubergines et le coulis de tomates.\nEtape 8\nEtaler la pâte à pizza puis la recouvrir de ce mélange.\nEtape 9\nAjouter les légumes puis disposer la mozzarella préalablement coupée en tranches\nEtape 10\nAssaisonner avec le sel et le poivre, ajouter les herbes de Provence et quelques olives picholines noires.\nEtape 11\nFaire cuire environ 20 minutes.'),
    (5, E'Etape 1\nPour la sauce tomate :\nEtape 2\nHachez l\'oignon puis faites-le revenir dans une poêle avec une cuillère d\'huile d\'olive à feux doux.\nEtape 3\nLorsque il est un peu doré, ajoutez le coulis de tomate, l\'ail écrasé ou haché selon les préférences, salez et poivrez.\nEtape 4\nAjoutez une cuillère à café de sucre pour enlever l\'acidité de la tomate, ainsi que le basilic ou d\'autres herbes de Provence pour parfumer.\nEtape 5\nLaissez mijoter à feux doux pendant une dizaine de minutes. Retirez du feu et laisser refroidir.\nEtape 6\nPour la garniture :\nEtape 7\nFaites cuire dans une poêle les 2 steaks hachés dans un peu d\'huile d\'olive, écrasez-les afin d\'en faire de la viande hachée, salez, poivrez, ajoutez des herbes de Provence et un peu de piment pour relever le goût si désiré. Retirez de la poêle et mettez de côté.\nEtape 8\nFaites griller les merguez de façon à en faire sortir le gras. Mettez de côté.\nEtape 9\nDans une autre poêle, faites revenir les champignons de Paris découpés en tranches dans un peu d\'huile d\'olive, saler et poivrer, en option ajoutez un peu de persil. Mettez de côté.\nEtape 10\nPour finir découpez les poivrons dans la forme désirée et découpez le reste de l\'oignon en rondelles.\nEtape 11\nFaites revenir le tout ensemble dans un peu d\'huile d\'olive à feux doux quelques minutes, sales et mettez de côté. On peut aussi ne pas cuire ces 2 ingrédients et les mettre crus directement sur la pizza.\nEtape 12\nPréparation de la pizza :\nEtape 13\nPréchauffez le four à 200°C (thermostat 6-7).\nEtape 14\nÉtalez la pâte, piquez-la à la fourchette, ajoutez la sauce tomate en évitant le bord.\nEtape 15\nDisposez des rondelles de mozzarella, puis ajoutez les autres ingrédients de façon équilibrée.\nEtape 16\nRedressez les bords de la pizza pour former un bourrelet.\nEtape 17\nEnfournez et laissez cuire entre 10 et 20 min en fonction du four et de la pâte choisie, le mieux est de surveiller la cuisson.\nEtape 18\nBon appétit.'),
    (6, E'Etape 1\nPréchauffer le four à 180°C (thermostat 6).\nEtape 2\nÉtaler la pâte à pizza sur une plaque du four.\nEtape 3\nDans un bol, mélanger le concentré de tomates avec le même volume d\'eau tiède de façon à obtenir une purée pas trop liquide.\nEtape 4\nAjouter l\'huile d\'olive.\nEtape 5\nÉtaler le tout à l\'aide d\'une cuillère sur la pâte, en allant presque jusqu\'aux bords.\nEtape 6\nSaupoudrer d\'herbes de Provence et d\'un peu de sel.\nEtape 7\nDans un autre bol, mélanger le thon égoutté avec le fromage blanc et les câpres.\nEtape 8\nNe pas assaisonner !\nEtape 9\nÉtaler le tout sur la pizza, si ça se mélange un peu avec la purée de tomates c\'est normal.\nEtape 10\nParsemer un peu d\'origan sur le tout, puis saupoudrer de fromage râpé.\nEtape 11\nEnfourner à 180°C pendant environ 20 min.\nEtape 12\nA déguster encore chaud, avec une salade.'),
    (7, E'Etape 1\nPréparation de la pâte:\nEtape 2\nÉmiettez la levure puis, diluer dans la moitié de l\'eau tiède. Laissez reposer 10 minutes.\nEtape 3\nDans un grand saladier, déposez la farine et le sel puis mélangez.\nEtape 4\nAjoutez dans le saladier: l\'huile, la levure diluée et le reste d\'eau tiède.\nEtape 5\nMélangez bien les ingrédients à l\'aide d\'une grosse cuillère par exemple.\nEtape 6\nFarinez un large plan de travail puis déposez la pâte.\nEtape 7\nPétrissez la pâte durant 10 minutes de manière énergique puis, frappez-là fort sur le plan de travail plusieurs fois.\nEtape 8\nLe résultat: la pâte doit être lisse, non collante et de petites bulles d\'air doivent apparaître dans la pâte.\nEtape 9\nLaissez reposer une heure (4 heures serait le mieux) dans un saladier recouvert d\'un linge humide et chaud afin que la pâte ne croûte pas et qu\'elle gonfle.\nEtape 10\nPréparation de la sauce napolitaine façon Gusteau:\nEtape 11\nDans une casserole, faites revenir les oignons émincés finement dans de l\'huile d\'olive.\nEtape 12\nUne fois que les oignons ont bien sué, ajoutez les tomates préalablement écrasées à la main dans un saladier.\nEtape 13\nAjoutez les gousses d\'ail écrasées, le thym, le laurier, le double concentré de tomates. Salez et poivrez.\nEtape 14\nLaissez mijoter à feux doux jusqu\'à ce que le mélange épaississe puis, à feux très doux, ajoutez le basilic frais bien nettoyé et ciselé.\nEtape 15\nAjoutez le sucre (Une pierre de sucre pour ma part).\nEtape 16\nLaissez encore mijoter doucement quelques minutes pour que le basilic se diffuse sans la sauce.\nEtape 17\nPassez la préparation au mixeur à soupe, légèrement afin de ne pas rendre la préparation trop liquide. Réservez.\nEtape 18\nPréparation des garnitures:\nEtape 19\nCoupez la mozzarella en fines tranches puis égouttez-là entre plusieurs feuilles d\'essuie-tout (Ceci afin qu\'elle ne rejette pas trop d\'eau lors de la cuisson).\nEtape 20\nNettoyez les feuilles de basilic frais.\nEtape 21\nRappez le parmigiano reggiano.\nEtape 22\nPréchauffez votre four électrique au thermostat 9 (270°c), 30 minutes avant de commencer à dresser vos pizzas. La chaleur doit être statique et non tournante, une chaleur en bas et gril en haut.\nEtape 23\nDisposez une grille à l\'étage le plus bas de votre four.\nEtape 24\nPréparation finale:\nEtape 25\nFarinez un large plan de travail, y déposer la pâte qui a doublé de volume durant l\'heure de repos.\nEtape 26\nÉcrasez la pâte pour enlever l\'excédent d\'air.\nEtape 27\nVoici la démarche à suivre précisément: d\'abord vous devez délimiter les bords avec le bout des doigts tout en étirant la pâte de façon à créer les bords de la pizza afin d\'avoir une croûte bien marquée comme on peut le voir sur la photo. Ensuite, étirez la pâte selon la méthode 12H/12H10\nEtape 28\nC\'est un coup de main à prendre mais vous n\'êtes pas obliger de faire voler la pizza si vous n\'y arrivez pas.\nEtape 29\nDéposez votre pâte sur une plaque à pizza.\nEtape 30\nDéposez une louche de sauce napolitaine façon Gusteau puis, étalez-là à l\'aide de la louche. Répartir la mozarella et le parmesan.\nEtape 31\nÀ l\'aide d\'un pinceau culinaire, badigeonnez rapidement d\'huile d\'olive les bords de la pizza afin qu\'ils dorent (En effet les fours de notre cuisine ne permettent pas d\'obtenir une croûte bien brunie comme les fours à pizzaïolo car nos four ne sont pas assez chauds).\nEtape 32\nEnfournez pour environ 8 à 10 minutes sans ouvrir.\nEtape 33\nÀ la sortie du four, disposez quelques feuilles de basilic.\nEtape 34\nLa pâte doit être fine et croustillante au milieu et plus épaisse et moelleuse sur les bords (La pizza italienne se différencie donc de la pizza américaine qui est épaisse partout comme on peut le retrouver avec les pizzas de fast-food')
;

INSERT INTO ingredient
    (name, stock, point_of_sale_id)
VALUES
    ('tomate', 50, 2),
    ('chèvre', 100, 2),
    ('champignon', 200, 2),
    ('mozzarella', 40, 2),
    ('olive', 300, 2),
    ('oignon', 50, 2)
;

INSERT INTO quantity_for_preparation
    (pizza_menu_id, ingredient_id, necessary_quantity)
VALUES
    (1, 1, 2),
    (2, 2, 1),
    (3, 4, 10),
    (4, 6, 1)
;

INSERT INTO request
    (customer_id, numero, date, price, list_pizzas, payment_method, point_of_sale_id)
VALUES
    (2, '0002468g65zt321j6', '2019-10-17', 15.5, E'- 4 fromages\n- Margherita', 'En ligne', 1)
;