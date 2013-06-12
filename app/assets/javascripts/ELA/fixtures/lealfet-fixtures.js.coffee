ELA.fixtures.leaflet = {}

# Hardcoded fixtures for sample map
ELA.fixtures.leaflet.SamplePoints = [
  {name: "Boy", author: "Roald Dahl", val: "1090", color: "green", latlng: [-0.1949462890625, 0.05712890625]      },
  {name: "My Life on the Mississippi", author: "Mark Twain", val: "", color: "red", latlng: [-0.193603515625, 0.076171875]         },
  {name: "Raisin in the Sun", author: "Lorraine Hansberry", val: "N/A", color: "yellow", latlng: [-0.2152099609375, 0.125]              },
  {name: "Pulling Up Stakes", author: "David Lubar", val: "410", color: "green", latlng: [-0.286376953125, 0.1473388671875]     },
  {name: "Sucker", author: "Carson McCullers", val: "990", color: "yellow", latlng: [-0.221923828125, 0.16064453125]       },
  {name: "Demystifying the Adolescent...", author: "Laurence Steinberg", val: "1410", color: "yellow", latlng: [-0.14306640625, 0.1893310546875]      },
  {name: "Music on the Mind ", author: "Sharon Begley", val: "1160", color: "green", latlng: [-0.1802978515625, 0.1964111328125]    },
  {name: "Train Your Brain: How...", author: "Katie Hart", val: "1450", color: "green", latlng: [-0.139404296875, 0.203369140625]      },
  {name: "Phineas Gage: A Gruesome...", author: "John Fleischmann", val: "1030", color: "yellow", latlng: [-0.1951904296875, 0.213623046875]      },
  {name: "Phineas Gage: Unravelling...", author: "John Fleischmann", val: "990", color: "yellow", latlng: [-0.20361328125, 0.2352294921875]     },
  {name: "Success is Counted Sweetest ", author: "Emily Dickinson", val: "N/A", color: "yellow", latlng: [-0.23193359375, 0.2672119140625]      },
  {name: "Raven", author: "Edgar Allan Poe", val: "N/A", color: "green", latlng: [-0.2218017578125, 0.2796630859375]      },
  {name: "Cask of Amontillado", author: "Edgar Allan Poe", val: "800", color: "red", latlng: [-0.2513427734375, 0.295166015625]    },
  {name: "Tell-Tale Heart", author: "Edgar Allan Poe", val: "1010", color: "yellow", latlng: [-0.2166748046875, 0.30810546875]     },
  {name: "Civil War Surgeons", author: "Leo Roesnhouse", val: "1010", color: "yellow", latlng: [-0.2008056640625, 0.3480224609375]      },
  {name: "Mr. Lincoln’s High Tech War", author: "Thomas B. Allen", val: "1180", color: "red", latlng: [-0.17919921875, 0.3565673828125]    },
  {name: "Across the Great Divide", author: "John Stauffer", val: "1170", color: "yellow", latlng: [-0.1812744140625, 0.37109375]      },
  {name: "Sarah Morgan Dawson Entry", author: "", val: "1010", color: "yellow", latlng: [-0.200927734375, 0.378173828125]         },
  {name: "Boys War", author: "Jim Murphy", val: "1160", color: "green", latlng: [-0.181396484375, 0.38818359375]      },
  {name: "Gettysburg Address", author: "Abraham Lincoln", val: "1450", color: "yellow", latlng: [-0.129150390625, 0.413818359375]       },
  {name: "Declaration of Independence", author: "Thomas Jefferson", val: "1470", color: "yellow", latlng: [-0.1282958984375, 0.4285888671875]      },
  {name: "Declaration of Sentiments", author: "Elizabeth Stanton", val: "1450", color: "red", latlng: [-0.1292724609375, 0.44189453125]    },
  {name: "Notes on the State of Virginia", author: "Thomas Jefferson", val: "1310", color: "yellow", latlng: [-0.1495361328125, 0.450439453125]      },
  {name: "Narrative of the Life of FD", author: "Frederick Douglass", val: "1080", color: "green", latlng: [-0.1943359375, 0.48828125]     },
  {name: "Incidents in the Life of a Slave...", author: "Harriet Jacobs", val: "1080", color: "green", latlng: [-0.205322265625, 0.51806640625]            },
  {name: "Runaway Notice for Harriet...", author: "James Norcum", val: "1420", color: "yellow", latlng: [-0.142822265625, 0.5216064453125]     },
  {name: "No Witchcraft for Sale", author: "Doris Lessing", val: "890", color: "white", latlng: [-0.2322998046875, 0.5284423828125]    },
  {name: "Tom Sawyer", author: "Mark Twain", val: "750", color: "green", latlng: [-0.2564697265625, 0.580078125]        },
  {name: "My Life on the Mississippi", author: "Mark Twain", val: "1190", color: "green",  latlng: [-0.1998291015625, 0.59765625]         }
]

# icons for leaflet map
ELA.fixtures.leaflet.icons =
  yellow:
    iconUrl: '/assets/icons/yellow.png',
    iconRetinaUrl: 'icons/yellow@2x.png',
    iconSize: [22, 22],
    iconAnchor: [11, 11],
    popupAnchor: [0, -11],
    shadowUrl: '/assets/icons/shadow.png',
    shadowRetinaUrl: 'icons/shadow@2x.png',
    shadowSize: [30, 33],
    shadowAnchor: [15, 15],
    riseOnHover: true

  green:
    iconUrl: '/assets/icons/green.png',
    iconRetinaUrl: 'icons/green@2x.png',
    iconSize: [22, 22],
    iconAnchor: [11, 11],
    popupAnchor: [0, -11],
    shadowUrl: '/assets/icons/shadow.png',
    shadowRetinaUrl: '/assets/icons/shadow@2x.png',
    shadowSize: [30, 33],
    shadowAnchor: [15, 15],
    riseOnHover: true

  red:
    iconUrl: '/assets/icons/red.png',
    iconRetinaUrl: '/assets/icons/red@2x.png',
    iconSize: [22, 22],
    iconAnchor: [11, 11],
    popupAnchor: [0, -11],
    shadowUrl: '/assets/icons/shadow.png',
    shadowRetinaUrl: '/assets/icons/shadow@2x.png',
    shadowSize: [30, 33],
    shadowAnchor: [15, 15],
    riseOnHover: true

  white:
    iconUrl: '/assets/icons/white.png',
    iconRetinaUrl: '/assets/icons/white@2x.png',
    iconSize: [22, 22],
    iconAnchor: [11, 11],
    popupAnchor: [0, -11],
    shadowUrl: '/assets/icons/shadow.png',
    shadowRetinaUrl: '/assets/icons/white@2x.png',
    shadowSize: [30, 33],
    shadowAnchor: [15, 15],
    riseOnHover: true