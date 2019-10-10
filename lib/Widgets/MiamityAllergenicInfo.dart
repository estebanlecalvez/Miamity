import 'package:flutter/material.dart';

class MiamityAllergenicInfo extends StatelessWidget {
  MiamityAllergenicInfo();

  final List<String> allergenicTitle = <String>[
    'Gluten',
    'Crustacés',
    'Oeufs',
    'Poissons',
    'Arachides',
    'Soja',
    'Lait',
    'Fruits à coques',
    'Céléri',
    'Moutarde',
    'Graines de sésames',
    'Molusques',
  ];
  final List<String> allergenicDescription = <String>[
    'Les pains, les pâtisseries, les pâtes, la semoule, la charcuterie (sauf jambon), les friandises (sauf pur sucre), les conserves dites "à l\'étuvée", bière.', // Gluten
    'Toutes sortes de fruits de mer, telles que: le crabe, le homard, la crevette grise, la crevette rose, la langouste, la seiche, les moules, les huîtres et les escargots', // Crustacés
    'Tous les produits industriels ou artisanaux dont les ingrédients sont inconnus et/ou contenant des œufs (blanc et jaune), les oeufs sous toutes leurs formes (coque, dur, poché, omelette, au plat), les oeufs en préparation (gratin, soufflés, beignets, crèmes, crêpes, quiches, pommes dauphines…), les oeufs en pâtisserie.', // Oeufs
    'Le poisson non transformé ou en conserves (y compris les produits à base de saumon), surtout les poissons de la mer, les animaux nourris de farine de poisson', // Poissons
    'Arachide, Beurre d\'arachide, Cacahuète et beurre de cacahuète, Farine d\'arachide, Huile d\'arachide, Noix de mandelona (arachide transformée), Noix artificielles, Protéines végétales d\'arachides, Protéines végétales hydrolysées d\'arachides, Mélanges de noix du commerce', // Arachides
    'Huile de soja, huiles à base de mélange, lait de soja, laitages à base de soja, graines de soja, farine de soja, tofu, tonyu, farine de soja, huile de soja, protéines de soja, lécithines de soja, graisses végétales, huiles végétales, protéines végétales et lécithines sans autre précision', // Soja
    'Lait de vache et de chèvre, lait en poudre, beurre, crème fraiche, fromage blanc, frais et à tartiner, boissons lactées, desserts à base de lait ', // Lait
    'Amandes, Pistaches, Noix, Noix de cajou, Noisettes, Noix de macadamia, Noix de pécan, Pignons de pin, Pistaches', // Fruits à coques
    '', // Céléri
    '', // Moutarde
    'Beni, graine de beni, gingelly et huile de gingelly, graines, sésamole et sésamoline, sesamum indicum, sim-sim, til, tahini (pâte à base de graines de sésame)', // Graines de sésames
    'Moules, palourdes, huîtres, clovisses, poulpes, calamars, crabes', // Molusques
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(5),
      title: Text(
        "Les différents allergènes et les aliments associés : ",
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                itemCount: allergenicTitle.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${allergenicTitle[index]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                      Text(
                        '${allergenicDescription[index]}',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
