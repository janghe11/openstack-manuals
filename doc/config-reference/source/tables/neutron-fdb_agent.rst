..
    Warning: Do not edit this file. It is automatically generated from the
    software project's code and your changes will be overwritten.

    The tool to generate this file lives in openstack-doc-tools repository.

    Please make any changes needed in the code, then run the
    autogenerate-config-doc tool from the openstack-doc-tools repository, or
    ask for help on the documentation mailing list, IRC channel or meeting.

.. _neutron-fdb_agent:

.. list-table:: Description of FDB agent configuration options
   :header-rows: 1
   :class: config-ref-table

   * - Configuration option = Default value
     - Description
   * - **[FDB]**
     -
   * - ``shared_physical_device_mappings`` =
     - (List) Comma-separated list of <physical_network>:<network_device> tuples mapping physical network names to the agent's node-specific shared physical network device between SR-IOV and OVS or SR-IOV and linux bridge
