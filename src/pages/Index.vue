<template>
  <q-page class="flex flex-center">
    <q-card>
      <div class="q-pa-md">
        <q-table
          grid
          title="Videos"
          :data="data"
          :columns="columns"
          row-key="name"
          :filter="filter"
          hide-header
          :pagination.sync="pagination"
        >
          <template v-slot:item="props">
            <div class="">
              <div class="q-pa-md">
                <div class="q-pa-md">
                  <!--
                    <q-video
                      :src="'/videos?v='+props.row.id"
                    />
                    -->
                  <a :href="'/videos?v='+props.row.id">
                    <q-img
                      :src="'/images?img=' + props.row.id"
                      style="width:250px;height:auto"
                    >
                     <div class="absolute-bottom text-subtitle1 text-center">
              {{props.row.name}}
          </div>
                    </q-img>
                  </a>
                </div>
              </div>
            </div>
          </template>
        </q-table>
      </div>
    </q-card>
  </q-page>
</template>

<script>
export default {
  data() {
    return {
      filter: "",
      pagination: {
        page: 1,
        rowsPerPage: 9
      },
      columns: [
        { name: "name", label: "Title", field: "name" },
        { name: "id", label: "ID", field: "id" }
      ],
      data: []
    };
  },
  async mounted() {
    let videos = await this.$M("GETVIDSLIST^YDBTUBEAPI");
    this.data = videos.LIST;
  },
  computed: {},

  watch: {},

  methods: {}
};
</script>
