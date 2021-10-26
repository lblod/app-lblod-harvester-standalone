alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [

      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://data.lblod.info/vocabularies/mobiliteit/MaatregelConcept",
                        "http://data.lblod.info/vocabularies/mobiliteit/Maatregelconceptcombinatie",
                        "https://data.vlaanderen.be/ns/mobiliteit#Verkeersbordconcept",
                        "http://data.vlaanderen.be/ns/mandaat#Verkiezingsresultaat",
                        "http://data.vlaanderen.be/ns/mandaat#RechtstreekseVerkiezing",
                        "http://data.vlaanderen.be/ns/mandaat#RechtsgrondBeeindiging",
                        "http://data.vlaanderen.be/ns/mandaat#RechtsgrondAanstelling",
                        "http://data.vlaanderen.be/ns/mandaat#Mandataris",
                        "http://www.w3.org/ns/person#Person",
                        "http://data.vlaanderen.be/ns/mandaat#TijdsgebondenEntiteit",
                        "http://data.vlaanderen.be/ns/mandaat#Fractie",
                        "http://data.vlaanderen.be/ns/mandaat#Kandidatenlijst",
                        "http://www.w3.org/ns/prov#Location",
                        "http://data.vlaanderen.be/ns/persoon#Geboorte",
                        "http://www.w3.org/ns/org#Membership",
                        "http://data.vlaanderen.be/ns/mandaat#Mandaat",
                        "http://mu.semte.ch/vocabularies/ext/BestuursfunctieCode",
                        "http://mu.semte.ch/vocabularies/ext/MandatarisStatusCode",
                        "http://mu.semte.ch/vocabularies/ext/BeleidsdomeinCode",
                        "http://mu.semte.ch/vocabularies/ext/GeslachtCode",
                        "http://mu.semte.ch/vocabularies/ext/BestuurseenheidClassificatieCode",
                        "http://mu.semte.ch/vocabularies/ext/BestuursorgaanClassificatieCode",
                        "http://www.w3.org/ns/org#Organization",
                        "http://schema.org/PostalAddress",
                        "http://www.w3.org/ns/org#Role",
                        "http://www.w3.org/ns/org#Site",
                        "http://schema.org/ContactPoint",
                        "http://www.w3.org/ns/locn#Address",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Bestuursfunctie",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Functionaris",
                        "http://data.lblod.info/vocabularies/leidinggevenden/FunctionarisStatusCode",
                        "http://www.w3.org/2004/02/skos/core#Concept",
                        "http://www.w3.org/2004/02/skos/core#ConceptScheme",
                        "http://xmlns.com/foaf/0.1/Document",
                        "http://www.w3.org/2004/02/skos/core#ConceptScheme",
                        "http://data.vlaanderen.be/ns/besluit#Agendapunt",
                        "http://data.vlaanderen.be/ns/besluit#Artikel",
                        "http://data.vlaanderen.be/ns/besluit#BehandelingVanAgendapunt",
                        "http://data.vlaanderen.be/ns/besluit#Besluit",
                        "http://data.vlaanderen.be/ns/besluit#Bestuurseenheid",
                        "http://data.vlaanderen.be/ns/besluit#Bestuursorgaan",
                        "http://data.vlaanderen.be/ns/besluit#Stemming",
                        "http://data.vlaanderen.be/ns/besluit#Vergaderactiviteit",
                        "http://data.vlaanderen.be/ns/besluit#Zitting",
                        "http://publications.europa.eu/resource/distribution/eli/owl/owl/eli.owl/#LegalResource",
                        "http://publications.europa.eu/resource/distribution/eli/owl/owl/eli.owl/#LegalResourceSubdivision",
                        "http://data.vlaanderen.be/ns/generiek#Versie",
                        "http://data.vlaanderen.be/ns/generiek#VersieVolgensGeldigeTijd",
                      ]
                    } } ] },

      # Harvesting
      %GroupSpec{
        name: "harvesting",
        useage: [:write, :read_for_write, :read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/harvesting",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://redpencil.data.gift/vocabularies/tasks/Task",
                        "http://vocab.deri.ie/cogs#Job",
                        "http://vocab.deri.ie/cogs#ScheduledJob",
                        "http://redpencil.data.gift/vocabularies/tasks/ScheduledTask",
                        "http://redpencil.data.gift/vocabularies/tasks/CronSchedule",
                        "http://schema.org/repeatFrequency",
                        "http://open-services.net/ns/core#Error",
                        "http://lblod.data.gift/vocabularies/harvesting/HarvestingCollection",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#RemoteDataObject",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#DataContainer",
                        "http://oscaf.sourceforge.net/ndo.html#DownloadEvent",
                        "http://www.w3.org/ns/dcat#Dataset",
                        "http://www.w3.org/ns/dcat#Distribution",
                        "http://www.w3.org/ns/dcat#Catalog"
                      ]
                    } } ] },

      # CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end
